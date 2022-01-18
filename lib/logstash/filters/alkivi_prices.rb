# encoding: utf-8
require "logstash/filters/base"
require 'csv'

# This  filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::AlkiviPrices < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #    {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "alkivi_prices"

  default :codec, "plain"

  # Replace the message with this value.
  config :source_country, :validate => :string
  config :source_type, :validate => :string

  public
  def register
    costs_file = '/etc/logstash/carriersip_costs.csv'
    if ENV.key?('ALKIVI_COSTS_FILE')
      costs_file = ENV["ALKIVI_COSTS_FILE"]
    end

    prices_file = '/etc/logstash/carriersip_prices.csv'
    if ENV.key?('ALKIVI_PRICES_FILE')
      prices_file = ENV["ALKIVI_PRICES_FILE"]
    end

    costs_data = CSV.parse(File.read(costs_file), headers: true)
    @costs_data = {}
    costs_data.each do |i|
      @costs_data[i["code"]] = i
    end

    prices_data = CSV.parse(File.read(prices_file), headers: true)
    @prices_data = {}
    prices_data.each do |i|
      @prices_data[i["code"]] = i
    end

  end # def register

  public
  def filter(event)

    source_country = event.get(@source_country)
    source_type = event.get(@source_type)
    billsec = event.get("billsec")

    wanted_key = "1"
    if source_type == "Mobile"
        wanted_key = "2"
    end

    csv_code = source_country + "-" + wanted_key

    costs_line = nil
    if @costs_data.key?(csv_code)
      costs_line = @costs_data[csv_code]
    end

    prices_line = nil
    if @prices_data.key?(csv_code)
      prices_line = @prices_data[csv_code]
    end

    cost0 = 0.0
    cost1 = 0.0
    cost2 = 0.0
    price0 = 0.0
    price1 = 0.0
    price2 = 0.0

    if billsec
      if costs_line
        cost0 = (billsec.to_f / 60 * costs_line["prix0"].to_f).round(6)
        cost1 = (billsec.to_f / 60 * costs_line["prix1"].to_f).round(6)
        cost2 = (billsec.to_f / 60 * costs_line["prix2"].to_f).round(6)
      end
      if prices_line
        price0 = (billsec.to_f / 60 * prices_line["prix0"].to_f).round(6)
        price1 = (billsec.to_f / 60 * prices_line["prix1"].to_f).round(6)
        price2 = (billsec.to_f / 60 * prices_line["prix2"].to_f).round(6)
      end
    end

    event.set("alkivi_cost_0", cost0)
    event.set("alkivi_cost_1", cost1)
    event.set("alkivi_cost_2", cost2)
    event.set("customer_cost_0", price0)
    event.set("customer_cost_1", price1)
    event.set("customer_cost_2", price2)

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::AlkiviPrices

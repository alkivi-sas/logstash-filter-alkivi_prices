# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/alkivi_prices"

describe LogStash::Filters::AlkiviPrices do
  describe "French Mobile" do
    let(:config) do <<-CONFIG
      filter {
        alkivi_prices {
           source_country => 'destination_number_country'
           source_type => 'destination_number_type'
        }
      }
    CONFIG
    end

    sample({"destination_number_country" => "FR", "destination_number_type" => "Mobile", "billsec" => "60"}) do
      expect(subject).to include("alkivi_cost_0")
      expect(subject.get('alkivi_cost_0')).to eq(10.0)

      expect(subject).to include("alkivi_cost_1")
      expect(subject.get('alkivi_cost_1')).to eq(20.0)

      expect(subject).to include("alkivi_cost_2")
      expect(subject.get('alkivi_cost_2')).to eq(30.0)

      expect(subject).to include("customer_cost_0")
      expect(subject.get('customer_cost_0')).to eq(10.0)

      expect(subject).to include("customer_cost_1")
      expect(subject.get('customer_cost_1')).to eq(20.0)

      expect(subject).to include("customer_cost_2")
      expect(subject.get('customer_cost_2')).to eq(30.0)
    end

    sample({"destination_number_country" => "FR", "destination_number_type" => "LandLine", "billsec" => "60"}) do
      expect(subject).to include("alkivi_cost_0")
      expect(subject.get('alkivi_cost_0')).to eq(1.0)

      expect(subject).to include("alkivi_cost_1")
      expect(subject.get('alkivi_cost_1')).to eq(2.0)

      expect(subject).to include("alkivi_cost_2")
      expect(subject.get('alkivi_cost_2')).to eq(3.0)

      expect(subject).to include("customer_cost_0")
      expect(subject.get('customer_cost_0')).to eq(1.0)

      expect(subject).to include("customer_cost_1")
      expect(subject.get('customer_cost_1')).to eq(2.0)

      expect(subject).to include("customer_cost_2")
      expect(subject.get('customer_cost_2')).to eq(3.0)
    end

    sample({"destination_number_country" => "Fake", "destination_number_type" => "LandLine", "billsec" => "60"}) do
      expect(subject).to include("alkivi_cost_0")
      expect(subject.get('alkivi_cost_0')).to eq(0.0)

      expect(subject).to include("alkivi_cost_1")
      expect(subject.get('alkivi_cost_1')).to eq(0.0)

      expect(subject).to include("alkivi_cost_2")
      expect(subject.get('alkivi_cost_2')).to eq(0.0)

      expect(subject).to include("customer_cost_0")
      expect(subject.get('customer_cost_0')).to eq(0.0)

      expect(subject).to include("customer_cost_1")
      expect(subject.get('customer_cost_1')).to eq(0.0)

      expect(subject).to include("customer_cost_2")
      expect(subject.get('customer_cost_2')).to eq(0.0)
    end

    sample({"destination_number_country" => "FR", "destination_number_type" => "LandLine", "billsec" => ""}) do
      expect(subject).to include("alkivi_cost_0")
      expect(subject.get('alkivi_cost_0')).to eq(0.0)

      expect(subject).to include("alkivi_cost_1")
      expect(subject.get('alkivi_cost_1')).to eq(0.0)

      expect(subject).to include("alkivi_cost_2")
      expect(subject.get('alkivi_cost_2')).to eq(0.0)

      expect(subject).to include("customer_cost_0")
      expect(subject.get('customer_cost_0')).to eq(0.0)

      expect(subject).to include("customer_cost_1")
      expect(subject.get('customer_cost_1')).to eq(0.0)

      expect(subject).to include("customer_cost_2")
      expect(subject.get('customer_cost_2')).to eq(0.0)
    end
  end
end

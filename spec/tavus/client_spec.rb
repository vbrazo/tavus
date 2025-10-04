# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Client do
  let(:api_key) { "test-api-key" }

  describe "#initialize" do
    it "creates a client with api_key" do
      client = described_class.new(api_key: api_key)
      expect(client.configuration.api_key).to eq(api_key)
    end

    it "raises error without api_key" do
      expect { described_class.new }.to raise_error(Tavus::ConfigurationError)
    end

    it "uses global configuration when available" do
      Tavus.configure do |config|
        config.api_key = api_key
      end

      client = described_class.new
      expect(client.configuration.api_key).to eq(api_key)
    end

    it "allows overriding base_url" do
      client = described_class.new(api_key: api_key, base_url: "https://custom.com")
      expect(client.configuration.base_url).to eq("https://custom.com")
    end

    it "allows overriding timeout" do
      client = described_class.new(api_key: api_key, timeout: 60)
      expect(client.configuration.timeout).to eq(60)
    end
  end

  describe "#conversations" do
    it "returns a Conversations resource" do
      client = described_class.new(api_key: api_key)
      expect(client.conversations).to be_a(Tavus::Resources::Conversations)
    end

    it "memoizes the resource" do
      client = described_class.new(api_key: api_key)
      expect(client.conversations).to be(client.conversations)
    end
  end

  describe "#personas" do
    it "returns a Personas resource" do
      client = described_class.new(api_key: api_key)
      expect(client.personas).to be_a(Tavus::Resources::Personas)
    end

    it "memoizes the resource" do
      client = described_class.new(api_key: api_key)
      expect(client.personas).to be(client.personas)
    end
  end
end


# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Configuration do
  describe "#initialize" do
    it "sets default values" do
      config = described_class.new

      expect(config.api_key).to be_nil
      expect(config.base_url).to eq(Tavus::Configuration::DEFAULT_BASE_URL)
      expect(config.timeout).to eq(Tavus::Configuration::DEFAULT_TIMEOUT)
    end
  end

  describe "#valid?" do
    it "returns false when api_key is nil" do
      config = described_class.new
      expect(config.valid?).to be false
    end

    it "returns false when api_key is empty" do
      config = described_class.new
      config.api_key = ""
      expect(config.valid?).to be false
    end

    it "returns true when api_key is present" do
      config = described_class.new
      config.api_key = "test-key"
      expect(config.valid?).to be true
    end
  end

  describe "#base_uri" do
    it "returns a URI object" do
      config = described_class.new
      expect(config.base_uri).to be_a(URI::HTTPS)
    end

    it "parses the base_url correctly" do
      config = described_class.new
      config.base_url = "https://custom.tavusapi.com"
      expect(config.base_uri.to_s).to eq("https://custom.tavusapi.com")
    end
  end
end


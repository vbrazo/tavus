# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Personas do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:personas) { described_class.new(client) }

  describe "#create" do
    it "creates a persona with system_prompt" do
      stub_request(:post, "https://tavusapi.com/v2/personas")
        .with(
          body: { system_prompt: "You are a coach" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { persona_id: "p123" }.to_json)

      response = personas.create(system_prompt: "You are a coach")
      expect(response["persona_id"]).to eq("p123")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/personas")
        .with(
          body: hash_including(
            system_prompt: "You are a coach",
            persona_name: "Coach"
          )
        )
        .to_return(status: 200, body: { persona_id: "p123" }.to_json)

      personas.create(
        system_prompt: "You are a coach",
        persona_name: "Coach"
      )
    end
  end

  describe "#get" do
    it "gets a persona by id" do
      stub_request(:get, "https://tavusapi.com/v2/personas/p123")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [{ persona_id: "p123" }] }.to_json)

      response = personas.get("p123")
      expect(response["data"]).to be_an(Array)
    end
  end

  describe "#list" do
    it "lists personas" do
      stub_request(:get, "https://tavusapi.com/v2/personas")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = personas.list
      expect(response["total_count"]).to eq(0)
    end
  end

  describe "#patch" do
    let(:operations) do
      [{ op: "replace", path: "/persona_name", value: "New Name" }]
    end

    it "patches a persona with operations" do
      stub_request(:patch, "https://tavusapi.com/v2/personas/p123")
        .with(body: operations.to_json)
        .to_return(status: 200, body: {}.to_json)

      response = personas.patch("p123", operations)
      expect(response).to be_a(Hash)
    end

    it "raises error if operations is not an array" do
      expect { personas.patch("p123", {}) }.to raise_error(ArgumentError)
    end

    it "raises error if operations is empty" do
      expect { personas.patch("p123", []) }.to raise_error(ArgumentError)
    end

    it "validates operation structure" do
      invalid_ops = [{ op: "replace" }] # missing path
      expect { personas.patch("p123", invalid_ops) }.to raise_error(ArgumentError)
    end
  end

  describe "#build_patch_operation" do
    it "builds a replace operation" do
      op = personas.build_patch_operation("/field", "value", operation: "replace")
      expect(op).to eq({ op: "replace", path: "/field", value: "value" })
    end

    it "builds a remove operation without value" do
      op = personas.build_patch_operation("/field", nil, operation: "remove")
      expect(op).to eq({ op: "remove", path: "/field" })
    end
  end

  describe "#update_field" do
    it "updates a single field" do
      stub_request(:patch, "https://tavusapi.com/v2/personas/p123")
        .with(body: [{ op: "replace", path: "/field", value: "value" }].to_json)
        .to_return(status: 200, body: {}.to_json)

      response = personas.update_field("p123", "/field", "value")
      expect(response).to be_a(Hash)
    end
  end

  describe "#delete" do
    it "deletes a persona" do
      stub_request(:delete, "https://tavusapi.com/v2/personas/p123")
        .to_return(status: 204, body: "")

      response = personas.delete("p123")
      expect(response[:success]).to be true
    end
  end
end


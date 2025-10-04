# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Guardrails do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:guardrails) { described_class.new(client) }

  describe "#create" do
    it "creates guardrails with name and data" do
      stub_request(:post, "https://tavusapi.com/v2/guardrails")
        .with(
          body: {
            name: "Test Guardrails",
            data: [{ guardrails_prompt: "No profanity" }]
          }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { guardrails_id: "g123" }.to_json)

      response = guardrails.create(
        name: "Test Guardrails",
        data: [{ guardrails_prompt: "No profanity" }]
      )
      expect(response["guardrails_id"]).to eq("g123")
    end

    it "creates guardrails with only name" do
      stub_request(:post, "https://tavusapi.com/v2/guardrails")
        .with(
          body: { name: "Test Guardrails" }.to_json
        )
        .to_return(status: 200, body: { guardrails_id: "g123" }.to_json)

      guardrails.create(name: "Test Guardrails")
    end

    it "creates guardrails with only data" do
      stub_request(:post, "https://tavusapi.com/v2/guardrails")
        .with(
          body: { data: [{ guardrails_prompt: "No profanity" }] }.to_json
        )
        .to_return(status: 200, body: { guardrails_id: "g123" }.to_json)

      guardrails.create(data: [{ guardrails_prompt: "No profanity" }])
    end

    it "creates empty guardrails" do
      stub_request(:post, "https://tavusapi.com/v2/guardrails")
        .with(headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" })
        .to_return(status: 200, body: { guardrails_id: "g123" }.to_json)

      response = guardrails.create
      expect(response["guardrails_id"]).to eq("g123")
    end
  end

  describe "#get" do
    it "gets guardrails by id" do
      stub_request(:get, "https://tavusapi.com/v2/guardrails/g123")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { guardrails_id: "g123" }.to_json)

      response = guardrails.get("g123")
      expect(response["guardrails_id"]).to eq("g123")
    end
  end

  describe "#list" do
    it "lists guardrails" do
      stub_request(:get, "https://tavusapi.com/v2/guardrails")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = guardrails.list
      expect(response["total_count"]).to eq(0)
    end

    it "includes pagination parameters" do
      stub_request(:get, "https://tavusapi.com/v2/guardrails?limit=20&page=2")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      guardrails.list(limit: 20, page: 2)
    end
  end

  describe "#patch" do
    let(:operations) do
      [
        { op: "replace", path: "/data/0/guardrails_prompt", value: "Updated prompt" }
      ]
    end

    it "patches guardrails with operations" do
      stub_request(:patch, "https://tavusapi.com/v2/guardrails/g123")
        .with(body: operations.to_json)
        .to_return(status: 200, body: {}.to_json)

      response = guardrails.patch("g123", operations)
      expect(response).to be_a(Hash)
    end

    it "raises error if operations is not an array" do
      expect { guardrails.patch("g123", {}) }.to raise_error(ArgumentError, "Operations must be an array")
    end

    it "raises error if operations is empty" do
      expect { guardrails.patch("g123", []) }.to raise_error(ArgumentError, "Operations cannot be empty")
    end

    it "validates operation structure" do
      invalid_ops = [{ op: "replace" }] # missing path
      expect { guardrails.patch("g123", invalid_ops) }.to raise_error(ArgumentError, /must have 'op' and 'path'/)
    end

    it "validates operation type" do
      invalid_ops = [{ op: "invalid", path: "/field" }]
      expect { guardrails.patch("g123", invalid_ops) }.to raise_error(ArgumentError, /must be one of/)
    end

    it "supports add operation" do
      add_ops = [{ op: "add", path: "/data/0/callback_url", value: "https://example.com" }]
      stub_request(:patch, "https://tavusapi.com/v2/guardrails/g123")
        .with(body: add_ops.to_json)
        .to_return(status: 200, body: {}.to_json)

      guardrails.patch("g123", add_ops)
    end

    it "supports remove operation" do
      remove_ops = [{ op: "remove", path: "/data/0/callback_url" }]
      stub_request(:patch, "https://tavusapi.com/v2/guardrails/g123")
        .with(body: remove_ops.to_json)
        .to_return(status: 200, body: {}.to_json)

      guardrails.patch("g123", remove_ops)
    end
  end

  describe "#build_patch_operation" do
    it "builds a replace operation" do
      op = guardrails.build_patch_operation("/field", "value", operation: "replace")
      expect(op).to eq({ op: "replace", path: "/field", value: "value" })
    end

    it "builds an add operation" do
      op = guardrails.build_patch_operation("/field", "value", operation: "add")
      expect(op).to eq({ op: "add", path: "/field", value: "value" })
    end

    it "builds a remove operation without value" do
      op = guardrails.build_patch_operation("/field", nil, operation: "remove")
      expect(op).to eq({ op: "remove", path: "/field" })
    end
  end

  describe "#update_field" do
    it "updates a single field" do
      stub_request(:patch, "https://tavusapi.com/v2/guardrails/g123")
        .with(body: [{ op: "replace", path: "/name", value: "New Name" }].to_json)
        .to_return(status: 200, body: {}.to_json)

      response = guardrails.update_field("g123", "/name", "New Name")
      expect(response).to be_a(Hash)
    end
  end

  describe "#delete" do
    it "deletes guardrails" do
      stub_request(:delete, "https://tavusapi.com/v2/guardrails/g123")
        .to_return(status: 204, body: "")

      response = guardrails.delete("g123")
      expect(response[:success]).to be true
    end
  end
end

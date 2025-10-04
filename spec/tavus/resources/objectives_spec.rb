# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Objectives do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:objectives) { described_class.new(client) }

  describe "#create" do
    let(:objectives_data) do
      [
        {
          objective_name: "collect_email",
          objective_prompt: "Get the user's email address"
        }
      ]
    end

    it "creates objectives with data" do
      stub_request(:post, "https://tavusapi.com/v2/objectives")
        .with(
          body: { data: objectives_data }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { objectives_id: "o123" }.to_json)

      response = objectives.create(data: objectives_data)
      expect(response["objectives_id"]).to eq("o123")
    end

    it "raises error if data is not an array" do
      expect { objectives.create(data: {}) }.to raise_error(ArgumentError, "data must be an array")
    end

    it "raises error if data is empty" do
      expect { objectives.create(data: []) }.to raise_error(ArgumentError, "data cannot be empty")
    end

    it "creates objectives with multiple items" do
      multi_objectives = [
        { objective_name: "collect_email", objective_prompt: "Get email" },
        { objective_name: "collect_name", objective_prompt: "Get name" }
      ]

      stub_request(:post, "https://tavusapi.com/v2/objectives")
        .with(body: { data: multi_objectives }.to_json)
        .to_return(status: 200, body: { objectives_id: "o123" }.to_json)

      objectives.create(data: multi_objectives)
    end
  end

  describe "#get" do
    it "gets an objective by id" do
      stub_request(:get, "https://tavusapi.com/v2/objectives/o123")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { objectives_id: "o123" }.to_json)

      response = objectives.get("o123")
      expect(response["objectives_id"]).to eq("o123")
    end
  end

  describe "#list" do
    it "lists objectives" do
      stub_request(:get, "https://tavusapi.com/v2/objectives")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = objectives.list
      expect(response["total_count"]).to eq(0)
    end

    it "includes pagination parameters" do
      stub_request(:get, "https://tavusapi.com/v2/objectives?limit=20&page=2")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      objectives.list(limit: 20, page: 2)
    end
  end

  describe "#patch" do
    let(:operations) do
      [
        { op: "replace", path: "/data/0/objective_name", value: "updated_name" }
      ]
    end

    it "patches an objective with operations" do
      stub_request(:patch, "https://tavusapi.com/v2/objectives/o123")
        .with(body: operations.to_json)
        .to_return(status: 200, body: {}.to_json)

      response = objectives.patch("o123", operations)
      expect(response).to be_a(Hash)
    end

    it "raises error if operations is not an array" do
      expect { objectives.patch("o123", {}) }.to raise_error(ArgumentError, "Operations must be an array")
    end

    it "raises error if operations is empty" do
      expect { objectives.patch("o123", []) }.to raise_error(ArgumentError, "Operations cannot be empty")
    end

    it "validates operation structure" do
      invalid_ops = [{ op: "replace" }] # missing path
      expect { objectives.patch("o123", invalid_ops) }.to raise_error(ArgumentError, /must have 'op' and 'path'/)
    end

    it "validates operation type" do
      invalid_ops = [{ op: "invalid", path: "/field" }]
      expect { objectives.patch("o123", invalid_ops) }.to raise_error(ArgumentError, /must be one of/)
    end

    it "supports multiple operations" do
      multi_ops = [
        { op: "replace", path: "/data/0/objective_name", value: "new_name" },
        { op: "replace", path: "/data/0/objective_prompt", value: "New prompt" },
        { op: "add", path: "/data/0/output_variables", value: ["email"] }
      ]

      stub_request(:patch, "https://tavusapi.com/v2/objectives/o123")
        .with(body: multi_ops.to_json)
        .to_return(status: 200, body: {}.to_json)

      objectives.patch("o123", multi_ops)
    end
  end

  describe "#build_patch_operation" do
    it "builds a replace operation" do
      op = objectives.build_patch_operation("/field", "value", operation: "replace")
      expect(op).to eq({ op: "replace", path: "/field", value: "value" })
    end

    it "builds an add operation" do
      op = objectives.build_patch_operation("/field", "value", operation: "add")
      expect(op).to eq({ op: "add", path: "/field", value: "value" })
    end

    it "builds a remove operation without value" do
      op = objectives.build_patch_operation("/field", nil, operation: "remove")
      expect(op).to eq({ op: "remove", path: "/field" })
    end
  end

  describe "#update_field" do
    it "updates a single field" do
      stub_request(:patch, "https://tavusapi.com/v2/objectives/o123")
        .with(body: [{ op: "replace", path: "/data/0/objective_name", value: "new_name" }].to_json)
        .to_return(status: 200, body: {}.to_json)

      response = objectives.update_field("o123", "/data/0/objective_name", "new_name")
      expect(response).to be_a(Hash)
    end
  end

  describe "#delete" do
    it "deletes an objective" do
      stub_request(:delete, "https://tavusapi.com/v2/objectives/o123")
        .to_return(status: 204, body: "")

      response = objectives.delete("o123")
      expect(response[:success]).to be true
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Conversations do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:conversations) { described_class.new(client) }

  describe "#create" do
    it "creates a conversation with replica_id and persona_id" do
      stub_request(:post, "https://tavusapi.com/v2/conversations")
        .with(
          body: { replica_id: "r123", persona_id: "p456" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { conversation_id: "c789" }.to_json)

      response = conversations.create(replica_id: "r123", persona_id: "p456")
      expect(response["conversation_id"]).to eq("c789")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/conversations")
        .with(
          body: hash_including(
            replica_id: "r123",
            conversation_name: "Test"
          )
        )
        .to_return(status: 200, body: { conversation_id: "c789" }.to_json)

      conversations.create(
        replica_id: "r123",
        persona_id: "p456",
        conversation_name: "Test"
      )
    end
  end

  describe "#get" do
    it "gets a conversation by id" do
      stub_request(:get, "https://tavusapi.com/v2/conversations/c789")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { conversation_id: "c789" }.to_json)

      response = conversations.get("c789")
      expect(response["conversation_id"]).to eq("c789")
    end
  end

  describe "#list" do
    it "lists conversations" do
      stub_request(:get, "https://tavusapi.com/v2/conversations")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = conversations.list
      expect(response["total_count"]).to eq(0)
    end

    it "includes query parameters" do
      stub_request(:get, "https://tavusapi.com/v2/conversations?limit=20&page=1")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      conversations.list(limit: 20, page: 1)
    end
  end

  describe "#end" do
    it "ends a conversation" do
      stub_request(:post, "https://tavusapi.com/v2/conversations/c789/end")
        .to_return(status: 200, body: {}.to_json)

      response = conversations.end("c789")
      expect(response).to be_a(Hash)
    end
  end

  describe "#delete" do
    it "deletes a conversation" do
      stub_request(:delete, "https://tavusapi.com/v2/conversations/c789")
        .to_return(status: 204, body: "")

      response = conversations.delete("c789")
      expect(response["success"]).to be true
    end
  end
end


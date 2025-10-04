# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Replicas do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:replicas) { described_class.new(client) }

  describe "#create" do
    it "creates a replica with train_video_url" do
      stub_request(:post, "https://tavusapi.com/v2/replicas")
        .with(
          body: { train_video_url: "https://example.com/video.mp4" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { replica_id: "r123" }.to_json)

      response = replicas.create(train_video_url: "https://example.com/video.mp4")
      expect(response["replica_id"]).to eq("r123")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/replicas")
        .with(
          body: hash_including(
            train_video_url: "https://example.com/video.mp4",
            consent_video_url: "https://example.com/consent.mp4",
            replica_name: "Test Replica",
            callback_url: "https://example.com/callback",
            model_name: "phoenix-3"
          )
        )
        .to_return(status: 200, body: { replica_id: "r123" }.to_json)

      replicas.create(
        train_video_url: "https://example.com/video.mp4",
        consent_video_url: "https://example.com/consent.mp4",
        replica_name: "Test Replica",
        callback_url: "https://example.com/callback",
        model_name: "phoenix-3"
      )
    end

    it "includes properties" do
      stub_request(:post, "https://tavusapi.com/v2/replicas")
        .with(
          body: hash_including(
            train_video_url: "https://example.com/video.mp4",
            properties: { custom_key: "custom_value" }
          )
        )
        .to_return(status: 200, body: { replica_id: "r123" }.to_json)

      replicas.create(
        train_video_url: "https://example.com/video.mp4",
        properties: { custom_key: "custom_value" }
      )
    end
  end

  describe "#get" do
    it "gets a replica by id without verbose" do
      stub_request(:get, "https://tavusapi.com/v2/replicas/r123")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { replica_id: "r123" }.to_json)

      response = replicas.get("r123")
      expect(response["replica_id"]).to eq("r123")
    end

    it "gets a replica by id with verbose" do
      stub_request(:get, "https://tavusapi.com/v2/replicas/r123?verbose=true")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { replica_id: "r123", details: "verbose" }.to_json)

      response = replicas.get("r123", verbose: true)
      expect(response["replica_id"]).to eq("r123")
    end
  end

  describe "#list" do
    it "lists replicas" do
      stub_request(:get, "https://tavusapi.com/v2/replicas")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = replicas.list
      expect(response["total_count"]).to eq(0)
    end

    it "includes pagination parameters" do
      stub_request(:get, "https://tavusapi.com/v2/replicas?limit=20&page=2")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      replicas.list(limit: 20, page: 2)
    end

    it "includes verbose parameter" do
      stub_request(:get, "https://tavusapi.com/v2/replicas?verbose=true")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      replicas.list(verbose: true)
    end

    it "filters by replica_type" do
      stub_request(:get, "https://tavusapi.com/v2/replicas?replica_type=user")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      replicas.list(replica_type: "user")
    end

    it "filters by replica_ids" do
      stub_request(:get, "https://tavusapi.com/v2/replicas?replica_ids=r123,r456")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      replicas.list(replica_ids: "r123,r456")
    end
  end

  describe "#delete" do
    it "soft deletes a replica" do
      stub_request(:delete, "https://tavusapi.com/v2/replicas/r123")
        .to_return(status: 204, body: "")

      response = replicas.delete("r123")
      expect(response[:success]).to be true
    end

    it "hard deletes a replica" do
      stub_request(:delete, "https://tavusapi.com/v2/replicas/r123?hard=true")
        .to_return(status: 204, body: "")

      response = replicas.delete("r123", hard: true)
      expect(response[:success]).to be true
    end
  end

  describe "#rename" do
    it "renames a replica" do
      stub_request(:patch, "https://tavusapi.com/v2/replicas/r123/name")
        .with(
          body: { replica_name: "New Name" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: {}.to_json)

      response = replicas.rename("r123", "New Name")
      expect(response).to be_a(Hash)
    end
  end
end

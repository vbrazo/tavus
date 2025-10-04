# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Videos do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:videos) { described_class.new(client) }

  describe "#create" do
    it "creates a video with replica_id and script" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(replica_id: "r123", script: "Hello world"),
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      response = videos.create(replica_id: "r123", script: "Hello world")
      expect(response["video_id"]).to eq("v123")
    end

    it "creates a video with replica_id and audio_url" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(replica_id: "r123", audio_url: "https://example.com/audio.mp3"),
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      response = videos.create(replica_id: "r123", audio_url: "https://example.com/audio.mp3")
      expect(response["video_id"]).to eq("v123")
    end

    it "raises error without script or audio_url" do
      expect do
        videos.create(replica_id: "r123")
      end.to raise_error(ArgumentError, "Either :script or :audio_url must be provided")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(
            replica_id: "r123",
            script: "Hello world",
            video_name: "Test Video",
            background_url: "https://example.com",
            callback_url: "https://example.com/callback",
            fast: true
          )
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      videos.create(
        replica_id: "r123",
        script: "Hello world",
        video_name: "Test Video",
        background_url: "https://example.com",
        callback_url: "https://example.com/callback",
        fast: true
      )
    end

    it "includes transparent_background with fast rendering" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(
            replica_id: "r123",
            script: "Hello",
            fast: true,
            transparent_background: true
          )
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      videos.create(
        replica_id: "r123",
        script: "Hello",
        fast: true,
        transparent_background: true
      )
    end

    it "includes watermark_image_url" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(
            replica_id: "r123",
            script: "Hello",
            watermark_image_url: "https://example.com/logo.png"
          )
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      videos.create(
        replica_id: "r123",
        script: "Hello",
        watermark_image_url: "https://example.com/logo.png"
      )
    end

    it "includes properties" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(
            replica_id: "r123",
            script: "Hello",
            properties: { custom_key: "value" }
          )
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      videos.create(
        replica_id: "r123",
        script: "Hello",
        properties: { custom_key: "value" }
      )
    end
  end

  describe "#generate_from_text" do
    it "generates video from text" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(replica_id: "r123", script: "Hello world"),
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      response = videos.generate_from_text(replica_id: "r123", script: "Hello world")
      expect(response["video_id"]).to eq("v123")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(
            replica_id: "r123",
            script: "Hello",
            video_name: "Test"
          )
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      videos.generate_from_text(replica_id: "r123", script: "Hello", video_name: "Test")
    end
  end

  describe "#generate_from_audio" do
    it "generates video from audio" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(replica_id: "r123", audio_url: "https://example.com/audio.mp3"),
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      response = videos.generate_from_audio(
        replica_id: "r123",
        audio_url: "https://example.com/audio.mp3"
      )
      expect(response["video_id"]).to eq("v123")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/videos")
        .with(
          body: hash_including(
            replica_id: "r123",
            audio_url: "https://example.com/audio.mp3",
            video_name: "Test"
          )
        )
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      videos.generate_from_audio(
        replica_id: "r123",
        audio_url: "https://example.com/audio.mp3",
        video_name: "Test"
      )
    end
  end

  describe "#get" do
    it "gets a video by id without verbose" do
      stub_request(:get, "https://tavusapi.com/v2/videos/v123")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { video_id: "v123" }.to_json)

      response = videos.get("v123")
      expect(response["video_id"]).to eq("v123")
    end

    it "gets a video by id with verbose" do
      stub_request(:get, "https://tavusapi.com/v2/videos/v123?verbose=true")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { video_id: "v123", thumbnails: [] }.to_json)

      response = videos.get("v123", verbose: true)
      expect(response["video_id"]).to eq("v123")
    end
  end

  describe "#list" do
    it "lists videos" do
      stub_request(:get, "https://tavusapi.com/v2/videos")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = videos.list
      expect(response["total_count"]).to eq(0)
    end

    it "includes pagination parameters" do
      stub_request(:get, "https://tavusapi.com/v2/videos?limit=20&page=2")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      videos.list(limit: 20, page: 2)
    end
  end

  describe "#delete" do
    it "soft deletes a video" do
      stub_request(:delete, "https://tavusapi.com/v2/videos/v123")
        .to_return(status: 204, body: "")

      response = videos.delete("v123")
      expect(response[:success]).to be true
    end

    it "hard deletes a video" do
      stub_request(:delete, "https://tavusapi.com/v2/videos/v123?hard=true")
        .to_return(status: 204, body: "")

      response = videos.delete("v123", hard: true)
      expect(response[:success]).to be true
    end
  end

  describe "#rename" do
    it "renames a video" do
      stub_request(:patch, "https://tavusapi.com/v2/videos/v123/name")
        .with(
          body: { video_name: "New Name" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: {}.to_json)

      response = videos.rename("v123", "New Name")
      expect(response).to be_a(Hash)
    end
  end
end

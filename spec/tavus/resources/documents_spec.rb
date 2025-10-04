# frozen_string_literal: true

require "spec_helper"

RSpec.describe Tavus::Resources::Documents do
  let(:client) { Tavus::Client.new(api_key: "test-key") }
  let(:documents) { described_class.new(client) }

  describe "#create" do
    it "creates a document with document_url" do
      stub_request(:post, "https://tavusapi.com/v2/documents")
        .with(
          body: { document_url: "https://example.com/doc.pdf" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { document_id: "d123" }.to_json)

      response = documents.create(document_url: "https://example.com/doc.pdf")
      expect(response["document_id"]).to eq("d123")
    end

    it "includes optional parameters" do
      stub_request(:post, "https://tavusapi.com/v2/documents")
        .with(
          body: hash_including(
            document_url: "https://example.com/doc.pdf",
            document_name: "Test Document",
            callback_url: "https://example.com/callback",
            tags: ["tag1", "tag2"]
          )
        )
        .to_return(status: 200, body: { document_id: "d123" }.to_json)

      documents.create(
        document_url: "https://example.com/doc.pdf",
        document_name: "Test Document",
        callback_url: "https://example.com/callback",
        tags: ["tag1", "tag2"]
      )
    end

    it "includes properties" do
      stub_request(:post, "https://tavusapi.com/v2/documents")
        .with(
          body: hash_including(
            document_url: "https://example.com/doc.pdf",
            properties: { key: "value" }
          )
        )
        .to_return(status: 200, body: { document_id: "d123" }.to_json)

      documents.create(
        document_url: "https://example.com/doc.pdf",
        properties: { key: "value" }
      )
    end
  end

  describe "#get" do
    it "gets a document by id" do
      stub_request(:get, "https://tavusapi.com/v2/documents/d123")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { document_id: "d123", document_name: "Test" }.to_json)

      response = documents.get("d123")
      expect(response["document_id"]).to eq("d123")
    end
  end

  describe "#list" do
    it "lists documents" do
      stub_request(:get, "https://tavusapi.com/v2/documents")
        .with(headers: { "x-api-key" => "test-key" })
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      response = documents.list
      expect(response["total_count"]).to eq(0)
    end

    it "includes query parameters" do
      stub_request(:get, "https://tavusapi.com/v2/documents?limit=20&page=1&status=ready")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      documents.list(limit: 20, page: 1, status: "ready")
    end

    it "supports filtering by tags" do
      stub_request(:get, "https://tavusapi.com/v2/documents?tags=tag1,tag2")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      documents.list(tags: "tag1,tag2")
    end

    it "supports sorting and searching" do
      stub_request(:get, "https://tavusapi.com/v2/documents?sort=ascending&name_or_uuid=test")
        .to_return(status: 200, body: { data: [], total_count: 0 }.to_json)

      documents.list(sort: "ascending", name_or_uuid: "test")
    end
  end

  describe "#update" do
    it "updates document metadata" do
      stub_request(:patch, "https://tavusapi.com/v2/documents/d123")
        .with(
          body: { document_name: "Updated Name" }.to_json,
          headers: { "x-api-key" => "test-key", "Content-Type" => "application/json" }
        )
        .to_return(status: 200, body: { document_id: "d123" }.to_json)

      response = documents.update("d123", document_name: "Updated Name")
      expect(response["document_id"]).to eq("d123")
    end

    it "updates tags" do
      stub_request(:patch, "https://tavusapi.com/v2/documents/d123")
        .with(
          body: { tags: ["new_tag"] }.to_json
        )
        .to_return(status: 200, body: { document_id: "d123" }.to_json)

      documents.update("d123", tags: ["new_tag"])
    end
  end

  describe "#delete" do
    it "deletes a document" do
      stub_request(:delete, "https://tavusapi.com/v2/documents/d123")
        .to_return(status: 204, body: "")

      response = documents.delete("d123")
      expect(response[:success]).to be true
    end
  end
end

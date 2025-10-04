# frozen_string_literal: true

module Tavus
  module Resources
    class Documents
      def initialize(client)
        @client = client
      end

      # Create a new document in the knowledge base
      # @param document_url [String] The URL of the document to be processed (required)
      # @param options [Hash] Additional optional parameters
      # @option options [String] :document_name Optional name for the document
      # @option options [String] :callback_url Optional URL for status updates
      # @option options [Hash] :properties Optional key-value pairs for additional properties
      # @option options [Array<String>] :tags Optional array of tags to categorize the document
      # @return [Hash] The created document details
      def create(document_url:, **options)
        body = options.merge(document_url: document_url)
        @client.post("/v2/documents", body: body)
      end

      # Get a single document by ID
      # @param document_id [String] The unique identifier of the document
      # @return [Hash] The document details
      def get(document_id)
        @client.get("/v2/documents/#{document_id}")
      end

      # List all documents
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of documents to return per page (default: 10)
      # @option options [Integer] :page Page number for pagination (0-based, default: 0)
      # @option options [String] :sort Sort direction (ascending, descending)
      # @option options [String] :status Filter documents by status
      # @option options [String] :name_or_uuid Search by name or UUID
      # @option options [String] :tags Comma-separated list of tags to filter by
      # @return [Hash] List of documents with pagination info
      def list(**options)
        @client.get("/v2/documents", params: options)
      end

      # Update a document's metadata
      # @param document_id [String] The unique identifier of the document
      # @param options [Hash] Update parameters
      # @option options [String] :document_name New name for the document
      # @option options [Array<String>] :tags New array of tags (overwrites existing)
      # @return [Hash] The updated document details
      def update(document_id, **options)
        @client.patch("/v2/documents/#{document_id}", body: options)
      end

      # Delete a document
      # @param document_id [String] The unique identifier of the document
      # @return [Hash] Success response
      def delete(document_id)
        @client.delete("/v2/documents/#{document_id}")
      end
    end
  end
end

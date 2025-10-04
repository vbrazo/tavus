# frozen_string_literal: true

module Tavus
  module Resources
    class Replicas
      def initialize(client)
        @client = client
      end

      # Create a new replica
      # @param train_video_url [String] Direct link to training video (required)
      # @param options [Hash] Additional optional parameters
      # @option options [String] :consent_video_url Direct link to consent video
      # @option options [String] :callback_url URL to receive callbacks on completion
      # @option options [String] :replica_name Name for the replica
      # @option options [String] :model_name Phoenix model version (default: phoenix-3)
      # @option options [Hash] :properties Additional properties
      # @return [Hash] The created replica details
      def create(train_video_url:, **options)
        body = options.merge(train_video_url: train_video_url)
        @client.post("/v2/replicas", body: body)
      end

      # Get a single replica by ID
      # @param replica_id [String] The unique identifier of the replica
      # @param verbose [Boolean] Include additional replica data (default: false)
      # @return [Hash] The replica details
      def get(replica_id, verbose: false)
        params = verbose ? { verbose: true } : {}
        @client.get("/v2/replicas/#{replica_id}", params: params)
      end

      # List all replicas
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of replicas to return per page
      # @option options [Integer] :page Page number to return
      # @option options [Boolean] :verbose Include additional replica data
      # @option options [String] :replica_type Filter by type (user, system)
      # @option options [String] :replica_ids Comma-separated list of replica IDs to filter
      # @return [Hash] List of replicas and total count
      def list(**options)
        @client.get("/v2/replicas", params: options)
      end

      # Delete a replica
      # @param replica_id [String] The unique identifier of the replica
      # @param hard [Boolean] If true, hard delete replica and assets (irreversible)
      # @return [Hash] Success response
      def delete(replica_id, hard: false)
        params = hard ? { hard: true } : {}
        @client.delete("/v2/replicas/#{replica_id}", params: params)
      end

      # Rename a replica
      # @param replica_id [String] The unique identifier of the replica
      # @param replica_name [String] New name for the replica
      # @return [Hash] Success response
      def rename(replica_id, replica_name)
        @client.patch("/v2/replicas/#{replica_id}/name", body: { replica_name: replica_name })
      end
    end
  end
end


# frozen_string_literal: true

module Tavus
  module Resources
    class Conversations
      def initialize(client)
        @client = client
      end

      # Create a new conversation
      # @param replica_id [String] The unique identifier for the replica
      # @param persona_id [String] The unique identifier for the persona
      # @param options [Hash] Additional optional parameters
      # @option options [Boolean] :audio_only Specifies whether the interaction should be voice-only
      # @option options [String] :callback_url A URL that will receive webhooks
      # @option options [String] :conversation_name A name for the conversation
      # @option options [String] :conversational_context Optional context for the conversation
      # @option options [String] :custom_greeting Custom greeting for the replica
      # @option options [Array<String>] :memory_stores Memory stores to use for the conversation
      # @option options [Array<String>] :document_ids Document IDs the persona can access
      # @option options [String] :document_retrieval_strategy Strategy for document retrieval (speed, quality, balanced)
      # @option options [Array<String>] :document_tags Document tags the replica can access
      # @option options [Boolean] :test_mode If true, conversation created but replica won't join
      # @option options [Hash] :properties Optional properties to customize the conversation
      # @return [Hash] The created conversation details
      def create(replica_id: nil, persona_id: nil, **options)
        body = options.dup
        body[:replica_id] = replica_id if replica_id
        body[:persona_id] = persona_id if persona_id

        @client.post("/v2/conversations", body: body)
      end

      # Get a single conversation by ID
      # @param conversation_id [String] The unique identifier of the conversation
      # @return [Hash] The conversation details
      def get(conversation_id)
        @client.get("/v2/conversations/#{conversation_id}")
      end

      # List all conversations
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of conversations to return per page (default: 10)
      # @option options [Integer] :page Page number to return (default: 1)
      # @option options [String] :status Filter by status (active, ended)
      # @return [Hash] List of conversations and total count
      def list(**options)
        @client.get("/v2/conversations", params: options)
      end

      # End a conversation
      # @param conversation_id [String] The unique identifier of the conversation
      # @return [Hash] Success response
      def end(conversation_id)
        @client.post("/v2/conversations/#{conversation_id}/end")
      end

      # Delete a conversation
      # @param conversation_id [String] The unique identifier of the conversation
      # @return [Hash] Success response
      def delete(conversation_id)
        @client.delete("/v2/conversations/#{conversation_id}")
      end
    end
  end
end

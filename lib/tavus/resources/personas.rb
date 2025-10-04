# frozen_string_literal: true

module Tavus
  module Resources
    class Personas
      def initialize(client)
        @client = client
      end

      # Create a new persona
      # @param system_prompt [String] The system prompt for the LLM (required for full pipeline mode)
      # @param options [Hash] Additional optional parameters
      # @option options [String] :persona_name A name for the persona
      # @option options [String] :pipeline_mode Pipeline mode (full, echo)
      # @option options [String] :context Context for the LLM
      # @option options [String] :default_replica_id Default replica ID for the persona
      # @option options [Array<String>] :document_ids Document IDs the persona can access
      # @option options [Array<String>] :document_tags Document tags the persona can access
      # @option options [Hash] :layers Configuration for perception, STT, LLM, TTS layers
      # @return [Hash] The created persona details
      def create(system_prompt: nil, **options)
        body = options.dup
        body[:system_prompt] = system_prompt if system_prompt

        @client.post("/v2/personas", body: body)
      end

      # Get a single persona by ID
      # @param persona_id [String] The unique identifier of the persona
      # @return [Hash] The persona details
      def get(persona_id)
        @client.get("/v2/personas/#{persona_id}")
      end

      # List all personas
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of personas to return per page (default: 10)
      # @option options [Integer] :page Page number to return (default: 1)
      # @option options [String] :persona_type Filter by type (user, system)
      # @return [Hash] List of personas and total count
      def list(**options)
        @client.get("/v2/personas", params: options)
      end

      # Update a persona using JSON Patch operations
      # @param persona_id [String] The unique identifier of the persona
      # @param operations [Array<Hash>] Array of JSON Patch operations
      # @example
      #   operations = [
      #     { op: "replace", path: "/persona_name", value: "Wellness Advisor" },
      #     { op: "add", path: "/layers/tts/tts_emotion_control", value: "true" },
      #     { op: "remove", path: "/layers/stt/hotwords" }
      #   ]
      # @return [Hash] Success response
      def patch(persona_id, operations)
        raise ArgumentError, "Operations must be an array" unless operations.is_a?(Array)
        raise ArgumentError, "Operations cannot be empty" if operations.empty?

        # Validate each operation has required fields
        operations.each do |op|
          raise ArgumentError, "Each operation must have 'op' and 'path'" unless op[:op] && op[:path]
          raise ArgumentError, "Operation 'op' must be one of: add, remove, replace, copy, move, test" unless %w[add remove replace copy move test].include?(op[:op])
        end

        @client.patch("/v2/personas/#{persona_id}", body: operations)
      end

      # Helper method to build patch operations
      # @param field [String] The field path (e.g., "/persona_name", "/layers/llm/model")
      # @param value [Object] The value to set
      # @param operation [String] The operation type (default: "replace")
      # @return [Hash] A JSON Patch operation
      def build_patch_operation(field, value, operation: "replace")
        op = { op: operation, path: field }
        op[:value] = value unless operation == "remove"
        op
      end

      # Convenient method to replace a field
      # @param persona_id [String] The unique identifier of the persona
      # @param field [String] The field path to update
      # @param value [Object] The new value
      # @return [Hash] Success response
      def update_field(persona_id, field, value)
        operation = build_patch_operation(field, value, operation: "replace")
        patch(persona_id, [operation])
      end

      # Delete a persona
      # @param persona_id [String] The unique identifier of the persona
      # @return [Hash] Success response
      def delete(persona_id)
        @client.delete("/v2/personas/#{persona_id}")
      end
    end
  end
end

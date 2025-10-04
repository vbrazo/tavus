# frozen_string_literal: true

module Tavus
  module Resources
    class Guardrails
      def initialize(client)
        @client = client
      end

      # Create new guardrails
      # @param name [String] Descriptive name for the collection of guardrails
      # @param data [Array<Hash>] Array of individual guardrails
      # @return [Hash] The created guardrails details
      def create(name: nil, data: [])
        body = {}
        body[:name] = name if name
        body[:data] = data unless data.empty?

        @client.post("/v2/guardrails", body: body)
      end

      # Get a single set of guardrails by ID
      # @param guardrails_id [String] The unique identifier of the guardrails
      # @return [Hash] The guardrails details
      def get(guardrails_id)
        @client.get("/v2/guardrails/#{guardrails_id}")
      end

      # List all guardrails
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of guardrails to return per page (default: 10)
      # @option options [Integer] :page Page number to return (default: 1)
      # @return [Hash] List of guardrails and total count
      def list(**options)
        @client.get("/v2/guardrails", params: options)
      end

      # Update guardrails using JSON Patch operations
      # @param guardrails_id [String] The unique identifier of the guardrails
      # @param operations [Array<Hash>] Array of JSON Patch operations
      # @example
      #   operations = [
      #     { op: "replace", path: "/data/0/guardrails_prompt", value: "Your updated prompt" },
      #     { op: "add", path: "/data/0/callback_url", value: "https://your-server.com/webhook" }
      #   ]
      # @return [Hash] Success response
      def patch(guardrails_id, operations)
        raise ArgumentError, "Operations must be an array" unless operations.is_a?(Array)
        raise ArgumentError, "Operations cannot be empty" if operations.empty?

        operations.each do |op|
          raise ArgumentError, "Each operation must have 'op' and 'path'" unless op[:op] && op[:path]
          raise ArgumentError, "Operation 'op' must be one of: add, remove, replace, copy, move, test" unless %w[add remove replace copy move test].include?(op[:op])
        end

        @client.patch("/v2/guardrails/#{guardrails_id}", body: operations)
      end

      # Helper method to build patch operations
      # @param field [String] The field path
      # @param value [Object] The value to set
      # @param operation [String] The operation type (default: "replace")
      # @return [Hash] A JSON Patch operation
      def build_patch_operation(field, value, operation: "replace")
        op = { op: operation, path: field }
        op[:value] = value unless operation == "remove"
        op
      end

      # Convenient method to update a field
      # @param guardrails_id [String] The unique identifier of the guardrails
      # @param field [String] The field path to update
      # @param value [Object] The new value
      # @return [Hash] Success response
      def update_field(guardrails_id, field, value)
        operation = build_patch_operation(field, value, operation: "replace")
        patch(guardrails_id, [operation])
      end

      # Delete guardrails
      # @param guardrails_id [String] The unique identifier of the guardrails
      # @return [Hash] Success response
      def delete(guardrails_id)
        @client.delete("/v2/guardrails/#{guardrails_id}")
      end
    end
  end
end

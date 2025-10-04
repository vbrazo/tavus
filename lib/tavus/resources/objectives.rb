# frozen_string_literal: true

module Tavus
  module Resources
    class Objectives
      def initialize(client)
        @client = client
      end

      # Create new objectives
      # @param data [Array<Hash>] Array of objectives to create
      # @return [Hash] The created objective details
      def create(data:)
        raise ArgumentError, "data must be an array" unless data.is_a?(Array)
        raise ArgumentError, "data cannot be empty" if data.empty?

        @client.post("/v2/objectives", body: { data: data })
      end

      # Get a single objective by ID
      # @param objectives_id [String] The unique identifier of the objective
      # @return [Hash] The objective details
      def get(objectives_id)
        @client.get("/v2/objectives/#{objectives_id}")
      end

      # List all objectives
      # @param options [Hash] Query parameters
      # @option options [Integer] :limit Number of objectives to return per page (default: 10)
      # @option options [Integer] :page Page number to return (default: 1)
      # @return [Hash] List of objectives and total count
      def list(**options)
        @client.get("/v2/objectives", params: options)
      end

      # Update an objective using JSON Patch operations
      # @param objectives_id [String] The unique identifier of the objective
      # @param operations [Array<Hash>] Array of JSON Patch operations
      # @example
      #   operations = [
      #     { op: "replace", path: "/data/0/objective_name", value: "updated_objective_name" },
      #     { op: "replace", path: "/data/0/objective_prompt", value: "Updated prompt" },
      #     { op: "add", path: "/data/0/output_variables", value: ["new_variable"] }
      #   ]
      # @return [Hash] Success response
      def patch(objectives_id, operations)
        raise ArgumentError, "Operations must be an array" unless operations.is_a?(Array)
        raise ArgumentError, "Operations cannot be empty" if operations.empty?

        operations.each do |op|
          raise ArgumentError, "Each operation must have 'op' and 'path'" unless op[:op] && op[:path]
          raise ArgumentError, "Operation 'op' must be one of: add, remove, replace, copy, move, test" unless %w[add remove replace copy move test].include?(op[:op])
        end

        @client.patch("/v2/objectives/#{objectives_id}", body: operations)
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
      # @param objectives_id [String] The unique identifier of the objective
      # @param field [String] The field path to update
      # @param value [Object] The new value
      # @return [Hash] Success response
      def update_field(objectives_id, field, value)
        operation = build_patch_operation(field, value, operation: "replace")
        patch(objectives_id, [operation])
      end

      # Delete an objective
      # @param objectives_id [String] The unique identifier of the objective
      # @return [Hash] Success response
      def delete(objectives_id)
        @client.delete("/v2/objectives/#{objectives_id}")
      end
    end
  end
end

# frozen_string_literal: true

require "net/http"
require "json"

module Tavus
  class Client
    attr_reader :configuration

    def initialize(api_key: nil, base_url: nil, timeout: nil)
      @configuration = Configuration.new
      @configuration.api_key = api_key || Tavus.configuration.api_key
      @configuration.base_url = base_url || Tavus.configuration.base_url
      @configuration.timeout = timeout || Tavus.configuration.timeout

      validate_configuration!
    end

    def conversations
      @conversations ||= Resources::Conversations.new(self)
    end

    def personas
      @personas ||= Resources::Personas.new(self)
    end

    def replicas
      @replicas ||= Resources::Replicas.new(self)
    end

    def objectives
      @objectives ||= Resources::Objectives.new(self)
    end

    def guardrails
      @guardrails ||= Resources::Guardrails.new(self)
    end

    def documents
      @documents ||= Resources::Documents.new(self)
    end

    def videos
      @videos ||= Resources::Videos.new(self)
    end

    def get(path, params: {})
      request(:get, path, params: params)
    end

    def post(path, body: {}, params: {})
      request(:post, path, body: body, params: params)
    end

    def patch(path, body: {}, params: {})
      request(:patch, path, body: body, params: params)
    end

    def delete(path, params: {})
      request(:delete, path, params: params)
    end

    private

    def validate_configuration!
      raise ConfigurationError, "API key is required" unless configuration.valid?
    end

    def request(method, path, body: {}, params: {})
      uri = build_uri(path, params)
      http = build_http(uri)
      request = build_request(method, uri, body)

      response = http.request(request)
      handle_response(response)
    rescue StandardError => e
      raise ApiError, "Request failed: #{e.message}"
    end

    def build_uri(path, params)
      uri = configuration.base_uri.dup
      uri.path = path
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end

    def build_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.read_timeout = configuration.timeout
      http.open_timeout = configuration.timeout
      http
    end

    def build_request(method, uri, body)
      request_class = case method
                      when :get then Net::HTTP::Get
                      when :post then Net::HTTP::Post
                      when :patch then Net::HTTP::Patch
                      when :delete then Net::HTTP::Delete
                      else raise ArgumentError, "Unsupported HTTP method: #{method}"
                      end

      request = request_class.new(uri)
      request["x-api-key"] = configuration.api_key
      request["Content-Type"] = "application/json"
      request["Accept"] = "application/json"

      if [:post, :patch].include?(method) && !body.empty?
        request.body = JSON.generate(body)
      end

      request
    end

    def handle_response(response)
      case response.code.to_i
      when 200, 201
        parse_json_response(response)
      when 204
        { success: true }
      when 400
        error = parse_json_response(response)
        raise BadRequestError, error["error"] || error["message"] || "Bad request"
      when 401
        error = parse_json_response(response)
        raise AuthenticationError, error["message"] || "Invalid access token"
      when 404
        raise NotFoundError, "Resource not found"
      when 422
        error = parse_json_response(response)
        raise ValidationError, error["error"] || error["message"] || "Validation failed"
      when 429
        raise RateLimitError, "Rate limit exceeded"
      when 500..599
        raise ServerError, "Server error: #{response.code}"
      else
        raise ApiError, "Unexpected response: #{response.code}"
      end
    end

    def parse_json_response(response)
      return {} if response.body.nil? || response.body.empty?

      JSON.parse(response.body)
    rescue JSON::ParserError
      { "raw_body" => response.body }
    end
  end
end

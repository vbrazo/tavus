# frozen_string_literal: true

require "uri"

module Tavus
  class Configuration
    attr_accessor :api_key, :base_url, :timeout

    DEFAULT_BASE_URL = "https://tavusapi.com"
    DEFAULT_TIMEOUT = 30

    def initialize
      @api_key = nil
      @base_url = DEFAULT_BASE_URL
      @timeout = DEFAULT_TIMEOUT
    end

    def valid?
      !api_key.nil? && !api_key.empty?
    end

    def base_uri
      URI.parse(base_url)
    end
  end
end

# frozen_string_literal: true

module Tavus
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class ApiError < Error; end
  class AuthenticationError < ApiError; end
  class BadRequestError < ApiError; end
  class NotFoundError < ApiError; end
  class ValidationError < ApiError; end
  class RateLimitError < ApiError; end
  class ServerError < ApiError; end
end

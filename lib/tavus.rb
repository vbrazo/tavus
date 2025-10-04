# frozen_string_literal: true

require_relative "tavus/version"
require_relative "tavus/configuration"
require_relative "tavus/client"
require_relative "tavus/errors"
require_relative "tavus/resources/conversations"
require_relative "tavus/resources/personas"
require_relative "tavus/resources/replicas"
require_relative "tavus/resources/objectives"
require_relative "tavus/resources/guardrails"
require_relative "tavus/resources/documents"
require_relative "tavus/resources/videos"

module Tavus
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end

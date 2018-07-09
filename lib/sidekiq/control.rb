# frozen_string_literal: true

require 'sidekiq/web'

require 'sidekiq/control/version'
require 'sidekiq/control/configuration'
require 'sidekiq/control/worker/instance'
require 'sidekiq/control/worker/param'
require 'sidekiq/control/web/application'
require 'sidekiq/control/web/params_parser'
require 'sidekiq/control/web/helpers'

module Sidekiq
  module Control
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end
      alias config configuration

      def configure
        yield configuration
      end

      def jobs
        @jobs ||= configuration.jobs.map { |job| Worker::Instance.new(job) }
      end
    end

    ::Sidekiq::Web.register(Web::Application)
    ::Sidekiq::Web.settings.locales << Web::Application::LOCALES_PATH
    ::Sidekiq::Web.tabs['Control'] = 'control'
  end
end

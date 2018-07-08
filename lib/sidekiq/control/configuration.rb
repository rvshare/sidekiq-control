# frozen_string_literal: true

module Sidekiq
  module Control
    class Configuration
      attr_writer :jobs
      attr_accessor :ignored_classes

      DEFAULT_IGNORED_CLASSES = %w(
        ApplicationJob
        Sidekiq::Batch::Callback
        Searchkick::ReindexV2Job
        Searchkick::BulkReindexJob
        Searchkick::ProcessBatchJob
        Searchkick::ProcessQueueJob
        ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper
      ).freeze

      def initialize
        self.ignored_classes = DEFAULT_IGNORED_CLASSES
      end

      def jobs
        @jobs ||= application_jobs.sort_by(&:name)
      end

      private

      def application_jobs
        rails_eager_load
        (sidekiq_jobs + active_jobs).select(&method(:select_class?))
      end

      def select_class?(klass)
        return if Sidekiq::Control.config.ignored_classes.include?(klass.name)
        klass.public_instance_methods(false).include?(:perform)
      end

      def sidekiq_jobs
        return [] unless defined?(::Sidekiq::Worker)
        find_descendants_of(::Sidekiq::Worker)
      end

      def active_jobs
        return [] unless defined?(::ActiveJob::Base)
        find_descendants_of(::ActiveJob::Base)
      end

      def find_descendants_of(obj)
        ObjectSpace.each_object(Class).select(&obj.method(:>))
      end

      def rails_eager_load
        ::Rails.application.eager_load! if defined?(::Rails) && !::Rails.env.production?
      end
    end
  end
end

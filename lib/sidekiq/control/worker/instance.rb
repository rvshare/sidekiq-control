# frozen_string_literal: true

module Sidekiq
  module Control
    module Worker
      class Instance
        UnsupportedJobType = Class.new(StandardError)

        attr_reader :job

        # @param [Class] job
        def initialize(job)
          @job = job
        end

        def name
          job.name
        end

        def params
          @params ||= worker_params.map { |e| Param.new(*e) }
        end

        def queue
          @queue ||= sidekiq_job? ? job.get_sidekiq_options['queue'] : job.queue_name
        end

        def other_perform_methods
          @other_perform_methods ||= job.singleton_methods(false).select { |m| m.to_s.start_with?('perform') }
        end

        def trigger(params, job_queue=nil)
          trigger_in(0, params, job_queue)
        end

        def trigger_in(seconds, params, job_queue=nil)
          if sidekiq_job?
            Sidekiq::Client.enqueue_to_in(job_queue || queue, seconds, job, *params)
          elsif active_job?
            job.set(wait: seconds, queue: job_queue || queue).perform_later(*params)
          else
            raise UnsupportedJobType
          end
        end

        private

        def sidekiq_job?
          job <= ::Sidekiq::Worker
        end

        def active_job?
          job <= ::ActiveJob::Base
        end

        def worker_params
          job.instance_method(:perform).parameters
        end
      end
    end
  end
end

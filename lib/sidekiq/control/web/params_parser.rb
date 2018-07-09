# frozen_string_literal: true

module Sidekiq
  module Control
    module Web
      class ParamsParser
        attr_reader :job
        attr_reader :params

        def self.values(job, params)
          new(job, params).values
        end

        def initialize(job, params)
          @job = job
          @params = params
        end

        def values
          job.params.map do |param|
            param.value = extract_value(param.name)
          end
        end

        private

        def extract_value(param_name)
          return if params[param_name].nil?
          cleanup(params[param_name])
        end

        def cleanup(value)
          value unless value.to_s.casecmp('nil').zero? && value.to_s.strip.empty?
        end
      end
    end
  end
end

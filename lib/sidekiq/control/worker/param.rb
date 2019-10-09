# frozen_string_literal: true

module Sidekiq
  module Control
    module Worker
      class Param
        TYPE_MAP = { req: 'required', opt: 'optional' }.freeze

        attr_reader :type
        attr_reader :name
        attr_reader :value

        def initialize(type, name=nil)
          @type = type
          @name = name.to_s
        end

        def value=(value)
          raise ArgumentError if required? && value.nil?

          @value = value
        end

        def type_name
          TYPE_MAP[@type]
        end

        def required?
          @type == :req
        end

        def optional?
          !required?
        end
      end
    end
  end
end

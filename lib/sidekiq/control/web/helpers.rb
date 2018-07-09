# frozen_string_literal: true

module Sidekiq
  module Control
    module Web
      module Helpers
        def link_to(path, text, options={})
          %(<a href="#{url_path(path)}"#{to_attributes(options)}>#{text}</a>)
        end

        def url_path(path)
          "#{root_path}#{path.sub(%r{^/}, '')}"
        end

        def display_params(params)
          params.map(&:name).reject { |n| n.start_with?('_') || n.empty? }.tap do |p|
            return 'None' if p.empty?
          end.join(', ')
        end

        def get_job_params(job, params)
          return [] if params[:perform].nil?
          ParamsParser.values(job, params[:perform])
        end

        private

        def to_attributes(data)
          # add a space before attributes since this is called without a space between the tag name and the attributes.
          " #{data.map { |k, v| "#{k}=\"#{v.is_a?(Array) ? v.join(' ') : v}\"" }.join(' ')}" unless data.empty?
        end
      end
    end
  end
end

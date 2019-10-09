# frozen_string_literal: true

require 'sidekiq/control/web/helpers'

module Sidekiq
  module Control
    module Web
      module Application
        WEB_PATH = File.expand_path(File.join('..', '..', '..', '..', 'web'), __dir__)
        VIEW_PATH = File.join(WEB_PATH, 'views')
        LOCALES_PATH = File.join(WEB_PATH, 'locales')

        # @param [Sidekiq::WebApplication] app
        def self.registered(app) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          app.helpers(Helpers)

          app.get('/control') do
            @jobs = Sidekiq::Control.jobs
            erb(File.read(File.join(VIEW_PATH, 'index.erb')))
          end

          app.get('/control/:name') do
            @job = Sidekiq::Control.jobs.find { |job| job.name == params[:name] }
            erb(File.read(File.join(VIEW_PATH, 'show_job.erb')))
          end

          app.post('/control') do
            job = Sidekiq::Control.jobs.find { |j| j.name == params[:job_name] }
            begin
              case params[:submit]
              when t('Run')
                job.trigger(get_job_params(job, params), params[:job_queue])
              when t('Schedule')
                job.trigger_in(params[:perform_in].to_f, get_job_params(job, params), params[:job_queue])
              when t('Perform')
                job.job.send(params[:perform_method])
              end

              redirect(url_path('control'))
            rescue StandardError => e
              @error = e
              erb(File.read(File.join(VIEW_PATH, 'error.erb')))
            end
          end
        end
      end
    end
  end
end

module Kapnismology
  # This is called when the user goes to the /smoke_test URL. This calls all the
  # smoke tests registered in the application and gather the results
  class SmokeTestsController < ApplicationController
    PROFILE_URL = 'http://tbd.mdsol.com'.freeze

    def index
      evaluations = SmokeTestCollection.evaluations(allowed_tags, blacklist)
      render json: results(evaluations).to_json, status: status(evaluations)
    end

    private

    def allowed_tags
      params[:tags] ? params[:tags].split(',') : [SmokeTest::RUNTIME_TAG]
    end

    def blacklist
      params[:skip].to_s.split(',')
    end

    def status(evaluations)
      if evaluations.passed?
        :ok
      else
        :service_unavailable
      end
    end

    def results(evaluations)
      items = evaluations.as_json.select { |e| e.has_key?(:passed) }
      {
        _links: {
          self: CGI.unescape(request.original_url),
          profile: PROFILE_URL
        },
        passed: evaluations.passed?,
        count: items.size,
        trace_id: ApplicationInformation.new.trace_id,
        codebase_revision: ApplicationInformation.new.codebase_revision,
        items: items
      }
    end
  end

end

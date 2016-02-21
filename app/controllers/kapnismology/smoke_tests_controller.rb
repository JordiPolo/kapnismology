module Kapnismology
  # This is called when the user goes to the /smoke_test URL. This calls all the
  # smoke tests registered in the application and gather the results
  class SmokeTestsController < ApplicationController
    def index
      evaluations = SmokeTest.evaluations(allowed_tags, blacklist)
      render text: evaluations.to_json, status: status(evaluations)
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
  end
end

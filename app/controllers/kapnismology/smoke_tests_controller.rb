module Kapnismology
  # This is called when the user goes to the /smoke_test URL. This calls all the
  # smoke tests registered in the application and gather the results
  class SmokeTestsController < ApplicationController
    def index
      response = SmokeTestResponse.new(SmokeTestCollection.evaluations(allowed_tags, blacklist))
      render json: response.render(request.original_url), status: response.status
    end

    private

    def allowed_tags
      params[:tags] ? params[:tags].split(',') : [SmokeTest::RUNTIME_TAG]
    end

    def blacklist
      params[:skip].to_s.split(',')
    end
  end
end

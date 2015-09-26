module Kapnismology
  class SmokeTestsController < ApplicationController
    def index
      evaluations = SmokeTest.evaluations
      render text: evaluations.to_json, status: status(evaluations)
    end

    private
    def status(evaluations)
      if evaluations.passed?
        :ok
      else
        :service_unavailable
      end
    end
  end
end

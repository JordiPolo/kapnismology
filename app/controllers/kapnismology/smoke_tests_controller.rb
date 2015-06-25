module Kapnismology
  class SmokeTestsController < ApplicationController
    def index
      result   = SmokeTest.result
      render text: result.to_json
    end
  end
end

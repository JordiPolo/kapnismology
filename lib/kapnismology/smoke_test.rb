require 'kapnismology/result'
require 'kapnismology/smoke_test_collection'

module Kapnismology

  # This class can be raised to make Kapnismology create a failed result from your smoke test
  class SmokeTestFailed < StandardError
    def initialize(data, message)
      @data = data
      @message = message
    end

    def result
      Kapnismology::Result.new(false, @data, @message)
    end
  end
  #
  # This is the base class for all the smoke tests.
  # Inherit from this class and implement the result and self.name method
  #
  class SmokeTest
    DEPLOYMENT_TAG = 'deployment'.freeze
    RUNTIME_TAG = 'runtime'.freeze
    DEFAULT_TAGS = [DEPLOYMENT_TAG, RUNTIME_TAG].freeze

    # Default constructor may be overwritten by child class
    def initialize
      @all_result_messages = []
    end

    def result
    end

    def __result__
      result_object = result
      unless result_object.is_a?(Kapnismology::BaseResult)
        message = "Smoke test #{self.class}, returned #{result_object.class} instead of a Result"
        result_object = Result.new(false, { returned_class: result_object.class }, message)
      end
    rescue SmokeTestFailed => e
      result_object = e.result
    rescue => e
      message = "Unrescued error happened in #{self.class}"
      result_object = Result.new(false, { exception: e.class, message: e.message }, message)
    ensure
      return result_object.add_extra_messages(@all_result_messages)
    end

    class << self
      def inherited(klass)
        SmokeTestCollection.add_smoke_test(klass)
      end

      def tags
        DEFAULT_TAGS
      end
    end

    protected

    def puts_to_result(message)
      @all_result_messages ||= []
      @all_result_messages.push(message)
    end

    # These classes makes it very simple to implementors of results to use them without the module name
    class Result < Kapnismology::Result
    end
    class NullResult < Kapnismology::NullResult
    end
    class Success < Kapnismology::Success
    end
    class SmokeTestFailed < Kapnismology::SmokeTestFailed
    end

  end
end

require 'kapnismology/result'
require 'kapnismology/smoke_test_collection'
require 'kapnismology/smoke_test_failed'

module Kapnismology
  #
  # This is the base class for all the smoke tests.
  # Inherit from this class and implement the result and self.name method
  #
  class SmokeTest
    DEPLOYMENT_TAG = 'deployment'.freeze
    RUNTIME_TAG = 'runtime'.freeze
    DEFAULT_TAGS = [DEPLOYMENT_TAG, RUNTIME_TAG].freeze

    def result
    end

    # Internally Kapnismology is calling this method. We are handling exceptions under the hood here
    def __result__
      start_time = Time.now
      execution = Timeout::timeout(self.class.timeout) { result }
      result_object = execution || Result.new(false, {}, 'This test has not returned any result')
      unless result_object.class.ancestors.include?(BaseResult)
        message = "Smoke test #{self.class}, returned #{result_object.class} instead of a Result"
        result_object = Result.new(false, { returned_class: result_object.class }, message)
      end
    rescue Kapnismology::SmokeTestFailed => e
      result_object = e.result
    rescue Timeout::Error => e
      message = "#{self.class} took more than #{self.class.timeout} seconds to finish and timed-out"
      result_object = Result.new(false, { exception: e.class, message: e.message }, message)
    rescue Exception => e # Socket, IO errors inherit from Exception, not StandardError
      message = "Unrescued error happened in #{self.class}"
      result_object = Result.new(false, { exception: e.class, message: e.message }, message)
    ensure
      @all_result_messages ||= []
      result_object.record_duration(start_time)
      return result_object.add_debug_messages(@all_result_messages)
    end

    class << self
      def inherited(klass)
        SmokeTestCollection.add_smoke_test(klass)
      end

      def tags
        DEFAULT_TAGS
      end

      def timeout
        10
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

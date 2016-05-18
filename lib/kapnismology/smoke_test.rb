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

    # Default constructor may be overwritten by child class
    def initialize
      @all_result_messages = []
    end

    def result
    end

    # Internally Kapnismology is calling this method. We are handling exceptions under the hood here
    def __result__
      Rails.logger.info("[Kapnismology] getting result")
      result_object = result || Result.new(false, {}, 'This test has not returned any result.')
      Rails.logger.info("[kapnismology] Result object #{result_object}")
      unless result_object.class.ancestors.include?(Kapnismology::BaseResult)
        message = "Smoke test #{self.class}, returned #{result_object.class} instead of a Result"
        result_object = Result.new(false, { returned_class: result_object.class }, message)
      end
    rescue Kapnismology::SmokeTestFailed => e
      Rails.logger.info("[kapnismology] rescuying testfailed #{e.message} #{e.class}")
      result_object = e.result
    rescue SmokeTestFailed => e
      Rails.logger.info("[kapnismology] rescuying testfailed #{e.message} #{e.class}")
      result_object = e.result
    rescue Exception => e # Rescuying networking and IO errors also.
      Rails.logger.info("[kapnismology] rescuying exception #{e.message} #{e.class} #{e.backtrace}")
      message = "Unrescued error happened in #{self.class}"
      result_object = Result.new(false, { exception: e.class, message: e.message, backtrace: e.backtrace }, message)
    ensure
      Rails.logger.info("got result object #{result_object}")
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
    class InfoResult < Kapnismology::InfoResult
    end
    class NullResult < Kapnismology::NullResult
    end
    class Success < Kapnismology::Success
    end
    class SmokeTestFailed < Kapnismology::SmokeTestFailed
    end

  end
end

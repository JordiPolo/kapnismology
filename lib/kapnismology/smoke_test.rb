require 'kapnismology/result'
require 'kapnismology/evaluation_collection'

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
      raise 'this method has to be implemented in inherited classes'
    end

    class << self
      def inherited(klass)
        smoke_tests << klass
      end

      def smoke_tests
        @smoke_tests ||= []
      end

      def evaluations(allowed_tags=[RUNTIME_TAG], blacklist=[])
        # We will run any class which categories are in the allowed list
        # and not blacklisted
        runable_tests = smoke_tests.select do |test|
          klass_name = test.name.split('::').last
          !blacklist.include?(klass_name) &&
            !(allowed_tags & test.tags).empty?
        end
        EvaluationCollection.new(runable_tests)
      end

      def tags
        DEFAULT_TAGS
      end
    end

    private

    # These classes makes it very simple to implementors of results to use them without the module name
    class Result < Kapnismology::Result
    end
    class NullResult < Kapnismology::NullResult
    end

  end
end

require 'kapnismology/evaluation_collection'

module Kapnismology

  # This class maintains the collection of all the smoke tests found in the system
  class SmokeTestCollection
    class << self
      def add_smoke_test(klass)
        smoke_tests << klass
      end

      def smoke_tests
        @smoke_tests ||= []
      end

      def evaluations(allowed_tags = [SmokeTest::RUNTIME_TAG], blacklist = [])
        # We will run any class which categories are in the allowed list
        # and not blacklisted
        runable_tests = smoke_tests.select do |test|
          klass_name = test.name.split('::').last
          !blacklist.include?(klass_name) &&
            !(allowed_tags & test.tags).empty?
        end
        EvaluationCollection.new(runable_tests)
      end
    end
  end
end

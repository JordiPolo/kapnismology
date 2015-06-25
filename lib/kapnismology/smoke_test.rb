
module Kapnismology

  class RakeTask
    def output
      evaluations = SmokeTest.result
      evaluations.each do |evaluation|
        puts "The smoke test #{evaluation.test_name} #{passed_or_failed(evaluation.passed)}"
        puts evaluation.message
        puts
      end
      all_passed = evaluations.map(&:passed).inject{|m, result| m && result}
      fail 'We have some failures in our smoke tests' unless all_passed
    end

    def passed_or_failed(passed)
      passed ? "passed" : "failed"
    end
  end

  #
  # This is the base class for all the smoke tests.
  # Inherit from this class and implement the result and self.name method
  #
  class SmokeTest

    def result
      raise 'this method has to be implemented in inherited classes'
    end

    def self.name
      raise 'this method has to be implemented in inherited classes'
    end

    class << self

      def inherited(klass)
        smoke_tests << klass
      end

      def smoke_tests
        @smoke_tests ||= []
      end

      def result
        smoke_tests.inject([]) do |memo, smoke_test|
          memo.push(Evaluation.new(smoke_test.name, smoke_test.new.result))
        end
      end
    end

  end
end
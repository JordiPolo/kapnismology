
module Kapnismology

  #
  # This is the base class for all the smoke tests.
  # Inherit from this class and implement the result and self.name method
  #
  class SmokeTest

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

      def evaluations
        EvaluationCollection.new(smoke_tests)
      end
    end

  end
end
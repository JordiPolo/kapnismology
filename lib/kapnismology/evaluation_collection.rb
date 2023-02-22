require 'json'

module Kapnismology
  # A collection of the evaluations of the smoke tests
  class EvaluationCollection
    include Enumerable

    def initialize(test_classes)
      @smoke_tests_classes = test_classes
    end

    def each(&_block)
      evaluations.each(&_block)
    end

    def passed?
      evaluations.all?(&:passed?)
    end

    def to_hash
      evaluations.map(&:to_hash)
    end

    def total_duration
      evaluations.inject(0) { |total, member| total += member.duration.to_i }
    end

    private

    def evaluations
      @evaluations ||= @smoke_tests_classes.each_with_object([]) do |klass, memo|
        evaluation = Evaluation.new(klass)
        memo << evaluation unless evaluation.result.class.ancestors.include?(Kapnismology::NotApplicableResult)
      end
    end
  end
end

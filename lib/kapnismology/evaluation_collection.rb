require 'json'

module Kapnismology
  # A collection of the evaluations of the smoke tests
  class EvaluationCollection
    include Enumerable

    def initialize(test_classes)
      @smoke_tests_classes = test_classes
    end

    def each(&_block)
      evaluations.each do |member|
        yield(member)
      end
    end

    def passed?
      evaluations.all?(&:passed?)
    end

    def to_json
      evaluations.map { |evaluation| evaluation.as_json }.to_json
    end

    private

    def evaluations
      @evaluations ||= @smoke_tests_classes.inject([]) do |memo, klass|
        evaluation = Evaluation.new(klass)
        memo << evaluation if !evaluation.result.class.ancestors.include?(Kapnismology::NotApplicableResult)
        memo
      end
    end
  end
end

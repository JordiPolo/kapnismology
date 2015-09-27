require 'json'

module Kapnismology
  class EvaluationCollection
    include Enumerable

    def initialize(smoke_tests)
      @smoke_tests = smoke_tests
    end

    def each(&block)
      evaluations.each do |member|
        block.call(member)
      end
    end

    def passed?
     evaluations.all?{|evaluation| evaluation.passed}
    end

    def to_json
      evaluations.to_json
    end

    private

    def evaluations
      @evaluations ||= @smoke_tests.map do |smoke_test|
        result = smoke_test.new.result
        Evaluation.new(smoke_test.name, result) if result
      end.compact
    end
  end

end

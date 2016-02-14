require 'json'

module Kapnismology
  # Mapping of test_name => result for each smoke test
  class Evaluation
    def initialize(test_class)
      @name = test_class.name.split('::').last
      @result = test_class.new.result || unavailable_result
    end

    def passed?
      @result.passed?
    end

    def as_json(_options = nil)
      { @name => @result.to_hash }
    end

    def to_s
      "The smoke test #{@name} #{passed_or_failed_text}\n #{@result.message}"
    end

    private

    def unavailable_result
      Result.new(false, {}, 'This test has not returned any result.')
    end

    def passed_or_failed_text
      passed? ? 'passed' : 'failed'
    end
  end
end

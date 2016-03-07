require 'json'
require 'kapnismology/terminal'

module Kapnismology
  # Mapping of test_name => returned result for each smoke test
  class Evaluation
    def initialize(test_class)
      @name = test_class.name.split('::').last
      @result = test_class.new.__result__ || unavailable_result
    end

    def passed?
      @result.passed?
    end

    def null_result?
      @result.is_a?(NullResult)
    end

    def as_json(_options = nil)
      { @name => @result.to_hash }
    end

    def to_s
      @result.to_s(@name)
    end

    private

    def unavailable_result
      Result.new(false, {}, 'This test has not returned any result.')
    end
  end
end

require 'json'
require 'kapnismology/terminal'

module Kapnismology
  # Mapping of test_name => returned result for each smoke test
  class Evaluation
    attr_reader :result

    def initialize(test_class)
      @name = test_class.name.split('::').last
      @result = test_class.new.__result__
    end

    def passed?
      @result.passed?
    end

    def to_hash(_options = nil)
      { name: @name.underscore }.merge(@result.to_hash)
    end

    def to_s
      @result.to_s(@name)
    end

    def duration
      @result.duration
    end
  end
end

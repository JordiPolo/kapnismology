require 'json'

module Kapnismology

  # Mapping of test_name => result for each smoke test
  class Evaluation
    extend Forwardable
    attr_reader :test_name
    def_delegators :@result, :data, :passed, :message

    def initialize(test_name, result)
      @test_name, @result = test_name, result
    end

    def to_json(_options = nil)
      {test_name => @result.to_hash}.to_json
    end
  end
end
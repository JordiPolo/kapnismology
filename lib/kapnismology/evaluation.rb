module Kapnismology

  # Mapping of test_name => result for each smoke test
  class Evaluation
    include Contracts
    extend Forwardable
    attr_reader :test_name
    def_delegators :@result, :data, :passed, :message

#    Contract String, Any
    def initialize(test_name, result)
      @test_name, @result = test_name, result
    end

    def to_json
      {test_name => @result.to_hash}.to_json
    end
  end
end
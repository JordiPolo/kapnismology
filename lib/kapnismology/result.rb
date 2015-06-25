module Kapnismology

  # This is the result of each smoke test.
  # This class makes sense to enforce smoke test to return something known
  # Params of the constructor:
  # * data   : Typically Array or Hash representing the result of the test
  # * passed : Boolean: true -> test passed, false -> test failed
  # * message: String: extra message set by the test if it wants to provide more information
  class Result
    include Contracts
    attr_reader :data, :passed, :message

   # Contract Any, Bool, String => nil
    def initialize(data, passed, message)
      @data, @passed, @message = data, passed, message
    end

    def to_hash
      {result: @data, passed: @passed, message: @message}
    end
  end
end
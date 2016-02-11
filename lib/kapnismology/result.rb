module Kapnismology

  # This is the result of each smoke test.
  # This class makes sense to enforce smoke test to return something known
  # Params of the constructor:
  # * passed : Boolean: true -> test passed, false -> test failed
  # * data   : Typically Array or Hash representing the result of the test
  # * message: String with an extra message set by the test to provide human readable information
  class Result
    attr_reader :data, :message

    def initialize(passed, data, message)
      raise ArgumentError, "passed must be true or false" unless !!passed == passed
      @passed, @data, @message = passed, data, message
    end

    def passed?
      !!@passed
    end

    def to_hash
      {passed: passed?, data: @data, message: @message}
    end
  end
end

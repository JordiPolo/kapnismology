module Kapnismology
  # This is the result of each smoke test.
  # This class makes sense to enforce smoke test to return something known
  # Params of the constructor:
  # * passed : Boolean: true -> test passed, false -> test failed
  # * data   : Typically Array or Hash representing the result of the test
  # * message: String with an extra message to provide human readable information
  class Result
    attr_reader :data, :message

    def initialize(passed, data, message)
      raise ArgumentError, 'passed must be true or false' unless !!passed == passed
      @passed = passed
      @data = data
      @message = message
    end

    def passed?
      !!@passed
    end

    def to_hash
      { passed: passed?, data: @data, message: @message }
    end
  end

  # Use this class when your test is not valid in the current situation
  # For instance when you have a test for deployments that have not happen, etc.
  class NullResult
    attr_reader :message
    def initialize(message = 'The result could not be determined')
      @message = message
    end
    def passed?
      true
    end
  end
end

module Kapnismology
  # This is the base class for all types of results.
  # It is useful to be able to test if the object is of a correct result type.
  # It also have methods to add information and serialize it.
  class BaseResult
    attr_reader :data, :message, :extra_messages # Deprecated but many users test on these properties
    def to_hash
      { passed: passed?, data: @data, message: @message, extra_messages: @extra_messages }
    end

    def to_s(name)
      <<-eos
#{format_passed(passed?)}: #{name}
#{format_extra_messages(@extra_messages)}#{Terminal.bold(@message)}
   #{@data}
eos
    end

    def add_extra_messages(messages)
      @extra_messages = (messages || []).compact.flatten
      self
    end

    def passed?
      !!@passed
    end

    private

    def format_extra_messages(extra_messages)
      if extra_messages.empty?
        ''
      else
        extra_messages.join("\n") + "\n"
      end
    end

    def format_passed(passed)
      passed ? Terminal.green('passed') : Terminal.red('failed')
    end
  end

  # This is the result of each smoke test.
  # This class makes sense to enforce smoke test to return something known
  # Params of the constructor:
  # * passed : Boolean: true -> test passed, false -> test failed
  # * data   : Typically Array or Hash representing the result of the test
  # * message: String with an extra message to provide human readable information
  class Result < BaseResult
    def initialize(passed, data, message)
      raise ArgumentError, 'passed must be true or false' unless !!passed == passed
      @passed = passed
      @data = data
      @message = message
      @extra_messages = []
    end
  end

  class NullResult < BaseResult
    def initialize(data, message = 'The result could not be determined')
      @passed = true
      @data = data
      @message = message
      @extra_messages = []
    end
  end

  # Use this class when your test is not valid in the current situation
  # For instance when you have a test for deployments that have not happen, etc.
  class Success < BaseResult
    def initialize(data, message)
      @passed = true
      @data = data
      @message = message
      @extra_messages = []
    end
  end
end

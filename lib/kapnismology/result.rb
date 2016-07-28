module Kapnismology
  # This is the base class for all types of results.
  # It is useful to be able to test if the object is of a correct result type.
  # It also have methods to add information and serialize it.
  class BaseResult
    attr_reader :data, :message, :debug_messages
    def to_hash
      { passed: passed?, data: @data, message: @message, debug_messages: @debug_messages }
    end

    def to_s(name)
      <<-eos
#{format_passed(passed?)}: #{name}
#{format_debug_messages(@debug_messages)}#{Terminal.bold(@message)}
   #{@data}
eos
    end

    def add_debug_messages(messages)
      @debug_messages = (messages || []).compact.flatten
      self
    end

    def passed?
      !!@passed
    end

    private

    def format_debug_messages(debug_messages)
      if debug_messages.empty?
        ''
      else
        debug_messages.join("\n") + "\n"
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
      raise ArgumentError, 'passed argument must be true or false' unless !!passed == passed
      @passed = passed
      @data = data
      @message = message
      @debug_messages = []
    end
  end

  # Deprecated NullResult class provided for compatibility.
  class NullResult < BaseResult
    def initialize(data, message = 'The result could not be determined')
      @passed = true
      @data = data
      @message = message
      @debug_messages = []
    end

    def to_s(name)
      <<-eos
#{Terminal.yellow('This test can not be run. Skipping...')}
#{super(name).chomp}
eos
    end

    # Nullresult does not output any data.
    def to_hash
      {}
    end

    private

    def format_passed(_passed)
      Terminal.yellow('Skipped')
    end
  end

  class NotApplicableResult < BaseResult
  end

  # Use this class when your test is not valid in the current situation
  # For instance when you have a test for deployments that have not happen, etc.
  class Success < BaseResult
    def initialize(data, message)
      @passed = true
      @data = data
      @message = message
      @debug_messages = []
    end
  end
end

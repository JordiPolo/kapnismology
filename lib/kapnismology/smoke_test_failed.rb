module Kapnismology
  # This class can be raised to make Kapnismology create a failed result from your smoke test
  class SmokeTestFailed < StandardError
    def initialize(data, message)
      @data = if data.class.ancestors.include?(Exception)
                { exception: data.class, message: data.message }
              else
                data
              end
      @message = message
    end

    def result
      Kapnismology::Result.new(false, @data, @message)
    end
  end
end

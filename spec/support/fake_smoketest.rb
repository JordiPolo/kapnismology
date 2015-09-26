module Kapnismology
  class FakeSmokeTest < SmokeTest
    def initialize(name, result)
      @name, @result = name, result
    end
    def name
      @name
    end
    def result
      @result
    end
  end
end
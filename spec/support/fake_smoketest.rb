module Kapnismology
  class FakeSmokeTest < SmokeTest
    def self.name
      @name
    end
    def self.name=(name)
      @name = name
    end
    def self.result=(result)
      @result = result
    end
    def self.result
      @result
    end
    def result
      self.class.result
    end
  end
end
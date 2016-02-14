module Kapnismology
  class FakeSmokeTest < SmokeTest
    class << self
      attr_accessor :name
      attr_accessor :result
    end

    def result
      self.class.result
    end
  end
end

module Kapnismology
  class FakeSmokeTest < SmokeTest
    class << self
      attr_accessor :name, :result, :tags
    end

    def result
      self.class.result
    end
  end

  class FakeSmokeTest2 < SmokeTest
    class << self
      attr_accessor :name, :result, :tags
    end

    def result
      self.class.result
    end
  end
end

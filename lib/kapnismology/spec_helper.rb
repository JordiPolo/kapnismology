require 'kapnismology/result'

module Kapnismology
  class RSpecResult < BaseResult
    attr_reader :data, :message, :extra_messages # Deprecated but many users test on these properties
    def initialize(result)
      hash = result.to_hash
      @data = hash[:data]
      @message = hash[:message]
      @passed = hash[:passed]
      @extra_messages = hash[:extra_messages]
    end
  end

  class SpecHelper
    def self.result_for(object)
      RSpecResult.new(object.__result__)
    end
  end
end

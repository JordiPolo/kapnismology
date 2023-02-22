require 'kapnismology/result'

module Kapnismology
  class RSpecResult < BaseResult
    attr_reader :data, :message, :debug_messages

    def initialize(result)
      hash = result.to_hash
      @data = hash[:data]
      @message = hash[:message]
      @passed = hash[:passed]
      @debug_messages = hash[:debug_messages]
    end
  end

  class SpecHelper
    def self.result_for(object)
      RSpecResult.new(object.__result__)
    end
  end
end

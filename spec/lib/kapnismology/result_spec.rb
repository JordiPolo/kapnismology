require 'spec_helper'

module Kapnismology
  RSpec.describe Result do
    let(:data) { [:berserk] }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }

    it 'provide access to data, passed and message' do
      expect(result.data).to eq(data)
      expect(result.passed?).to eq(passed)
      expect(result.message).to eq(message)
    end

    it 'creates a hash with its data' do
      expect(result.to_hash).to eq(passed: passed, data: data, message: message)
    end
  end
end

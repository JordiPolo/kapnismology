require 'spec_helper'

module Kapnismology
  RSpec.describe Evaluation do
    let(:data) {[:berserk]}
    let(:passed) {true}
    let(:message) {'黄金時代'}
    let(:result) {Result.new(data, passed, message)}
    let(:name) {'guts'}
    let(:evaluation) {Evaluation.new(name, result)}

    it 'creates a json representation' do
      expected = '{"guts":{"result":["berserk"],"passed":true,"message":"黄金時代"}}'
      expect(evaluation.to_json).to eq(expected)
    end

    it 'has access to the test_name' do
      expect(evaluation.test_name).to eq(name)
    end

    it 'hast access to the result information' do
      expect(evaluation.data).to eq(data)
      expect(evaluation.passed).to eq(passed)
      expect(evaluation.message).to eq(message)
    end

  end
end
require 'spec_helper'

module Kapnismology

  RSpec.describe EvaluationCollection do
    let(:data) {[:berserk]}
    let(:passed) {true}
    let(:message) {'黄金時代'}
    let(:result) {Result.new(data, passed, message)}
    let(:name) {'guts'}
    let(:smoke_tests) {[FakeSmokeTest.new(name, result)]}
    let(:evaluations) {EvaluationCollection.new(smoke_tests)}

    context 'all evaluation passed' do
      it '#passed? is true' do
        expect(evaluations.passed?).to eq(true)
      end
    end

    context 'not all the evaluations passed' do
      let(:result) {Result.new(data, false, message)}
      it '#passed? is true' do
        expect(evaluations.passed?).to eq(false)
      end
    end

    it 'returns a json object' do
      expected = '[{"guts":{"result":["berserk"],"passed":true,"message":"黄金時代"}}]'
      expect(evaluations.to_json).to eq(expected)
    end

  end
end
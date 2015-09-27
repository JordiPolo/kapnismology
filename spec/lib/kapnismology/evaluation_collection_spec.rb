require 'spec_helper'

module Kapnismology

  RSpec.describe EvaluationCollection do
    let(:data) {[:berserk]}
    let(:passed) {true}
    let(:message) {'黄金時代'}
    let(:result) {Result.new(data, passed, message)}
    let(:name) {'guts'}
    let(:smoke_tests) {[FakeSmokeTest]}
    let(:evaluations) {EvaluationCollection.new(smoke_tests)}

    context 'all evaluation passed' do
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = result
      end
      it '#passed? is true' do
        expect(evaluations.passed?).to eq(true)
      end
      it 'returns a json object' do
        expected = '[{"test_name":"guts","result":{"result":["berserk"],"passed":true,"message":"黄金時代"}}]'
        expect(evaluations.to_json).to eq(expected)
      end
    end

    context 'not all the evaluations passed' do
      let(:result) {Result.new(data, false, message)}
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = result
      end
      it '#passed? is true' do
        expect(evaluations.passed?).to eq(false)
      end
    end

  end
end
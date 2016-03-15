require 'spec_helper'

module Kapnismology
  RSpec.describe EvaluationCollection do
    let(:data) { [:berserk] }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }
    let(:name) { 'guts' }
    let(:smoke_tests) { [FakeSmokeTest, FakeSmokeTest2] }
    let(:evaluations) { EvaluationCollection.new(smoke_tests) }
    let(:name2) { 'gits' }

    context 'all evaluation passed' do
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = result
        FakeSmokeTest2.name = name2
        FakeSmokeTest2.result = result
      end
      it '#passed? is true' do
        expect(evaluations.passed?).to eq(true)
      end
      it 'returns a json object' do
        first  = { guts: { passed:true, data:["berserk"], message: "黄金時代", extra_messages:[]}}
        second  = { gits: { passed:true, data:["berserk"], message: "黄金時代", extra_messages:[]}}
        expected = [first, second].to_json
        expect(evaluations.to_json).to eq(expected)
      end
    end

    context 'not all the evaluations passed' do
      let(:failed_result) { Result.new(false, data, message) }
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = failed_result
        FakeSmokeTest2.name = name2
        FakeSmokeTest2.result = result
      end
      it '#passed? is false' do
        expect(evaluations.passed?).to eq(false)
      end
      it 'returns a json object' do
        first  = { guts: { passed:false, data:["berserk"], message: "黄金時代", extra_messages:[]}}
        second  = { gits: { passed:true, data:["berserk"], message: "黄金時代", extra_messages:[]}}
        expected = [first, second].to_json
        expect(evaluations.to_json).to eq(expected)
      end
    end

    context 'Some result could not be evaluated' do
      let(:null_result) { NullResult.new(data, message) }
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = result
        FakeSmokeTest2.name = name2
        FakeSmokeTest2.result = null_result
      end
      it '#passed? is true' do
        expect(evaluations.passed?).to eq(true)
      end
      it 'returns a json object without passed data' do
        first  = { guts: { passed:true, data:["berserk"], message: "黄金時代", extra_messages:[]}}
        second  = { gits: { data:["berserk"], message: "黄金時代", extra_messages:[]}}
        expected = [first, second].to_json
        expect(evaluations.to_json).to eq(expected)
      end
    end
  end
end

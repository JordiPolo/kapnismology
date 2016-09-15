require 'spec_helper'

module Kapnismology
  RSpec.describe Evaluation do
    class TestSmokeTest
      def result
        Result.new(true, { title: 'berserk' }, '黄金時代') # defined down there in the let
      end

      def __result__
        result
      end
    end
    let(:evaluation) { Evaluation.new(TestSmokeTest) }

    it 'creates a hash that can be converted to a JSON representation' do
      expected = { name: 'test_smoke_test', passed: true, data: { title: 'berserk' }, message: "黄金時代", debug_messages: [] }
      expect(evaluation.as_json).to eq(expected)
    end

    it 'knows if the test passed' do
      expect(evaluation.passed?).to eq(true)
    end

    it 'creates a string representation' do
      expected = %|#{Terminal.green('passed')}: TestSmokeTest\n\e[1m黄金時代\e[0m\n   {:title=>"berserk"}\n|
      expect(evaluation.to_s).to eq(expected)
    end
  end
end

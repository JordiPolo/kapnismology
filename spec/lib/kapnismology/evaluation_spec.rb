require 'spec_helper'

module Kapnismology
  RSpec.describe Evaluation do
    class TestSmokeTest
      def result
        Result.new(true, [:berserk], '黄金時代') # defined down there in the let
      end

      def __result__
        result
      end
    end
    let(:evaluation) { Evaluation.new(TestSmokeTest) }

    it 'creates a json representation' do
      expected = '{"TestSmokeTest":{"passed":true,"data":["berserk"],"message":"黄金時代","extra_messages":[]}}'
      expect(evaluation.to_json).to eq(expected)
    end

    it 'knows if the test passed' do
      expect(evaluation.passed?).to eq(true)
    end

    it 'creates a string representation' do
      expected = "#{Terminal.green('passed')}: TestSmokeTest\n\e[1m黄金時代\e[0m\n   [:berserk]\n"
      expect(evaluation.to_s).to eq(expected)
    end
  end
end

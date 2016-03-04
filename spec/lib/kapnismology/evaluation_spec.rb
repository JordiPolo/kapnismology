require 'spec_helper'

module Kapnismology
  RSpec.describe Evaluation do
    class TestSmokeTest
      def result
        Result.new(true, [:berserk], '黄金時代') # defined down there in the let
      end
    end
    let(:evaluation) { Evaluation.new(TestSmokeTest) }

    it 'creates a json representation' do
      expected = '{"TestSmokeTest":{"passed":true,"data":["berserk"],"message":"黄金時代"}}'
      expect(evaluation.to_json).to eq(expected)
    end

    it 'knows if the test passed' do
      expect(evaluation.passed?).to eq(true)
    end

    it 'creates a string representation' do
      expected = "The smoke test TestSmokeTest \e[32m\e[1mpassed\e[0m\n  黄金時代\n[:berserk]\n"
      expect(evaluation.to_s).to eq(expected)
    end
  end
end

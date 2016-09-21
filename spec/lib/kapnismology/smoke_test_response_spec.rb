require 'spec_helper'

module Kapnismology
  RSpec.describe SmokeTestResponse do
    let(:data) { { title: 'berserk' } }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }
    let(:name) { 'guts' }
    let(:smoke_tests) { [FakeSmokeTest, FakeSmokeTest2] }
    let(:evaluations) { EvaluationCollection.new(smoke_tests) }
    let(:run) { SmokeTestResponse.new(evaluations) }
    let(:request_url) { 'http://sandbox.imedidata.net/test'}
    let(:profile_url) { 'http://tbd.mdsol.com' }
    let(:name2) { 'gits' }

    context 'all evaluations passed' do
      let(:first) { { name: 'guts', passed: true, data: { title: 'berserk' }, message: "黄金時代", debug_messages: [] } }
      let(:second) { { name: 'gits', passed: true, data: { title: 'berserk' }, message: "黄金時代", debug_messages: [] } }
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = result
        FakeSmokeTest2.name = name2
        FakeSmokeTest2.result = result
      end

      it '#status is OK' do
        expect(run.status).to eq(200)
      end

      it '#render includes the smoke test count and items, links and passed status' do
        expect(run.render(request_url)).to include_json(
          _links: { self: request_url, profile: profile_url },
          passed: true,
          count: 2,
          items: [first, second]
        )
      end
    end

    context 'not all the evaluations passed' do
      let(:failed_result) { Result.new(false, data, message) }
      let(:first) { { name: 'guts', passed: false, data: { title: 'berserk' }, message: "黄金時代", debug_messages: [] } }
      let(:second) { { name: 'gits', passed: true, data: { title: 'berserk' }, message: "黄金時代", debug_messages: [] } }
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = failed_result
        FakeSmokeTest2.name = name2
        FakeSmokeTest2.result = result
      end

      it '#status is service_unavailable' do
        expect(run.status).to eq(503)
      end

      it '#render includes the smoke test count and items, links and passed status' do
        expect(run.render(request_url)).to include_json(
          _links: { self: request_url, profile: profile_url },
          passed: false,
          count: 2,
          items: [first, second]
        )
      end
    end

    context 'Some result could not be evaluated' do
      let(:null_result) { NullResult.new(data, message) }
      let(:first) { { name: 'guts', passed: true, data: { title: 'berserk' }, message: "黄金時代", debug_messages: [] } }
      let(:second) { { name: 'gits' } }
      before do
        FakeSmokeTest.name = name
        FakeSmokeTest.result = result
        FakeSmokeTest2.name = name2
        FakeSmokeTest2.result = null_result
      end

      it '#status is OK' do
        expect(run.status).to eq(200)
      end

      it '#render includes the smoke test count and items, links and passed status' do
        expect(run.render(request_url)).to include_json(
          _links: { self: request_url, profile: profile_url },
          passed: true,
          count: 1,
          items: [first]
        )
      end
    end
  end
end

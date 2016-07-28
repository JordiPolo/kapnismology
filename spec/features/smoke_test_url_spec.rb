require 'spec_helper'

module Kapnismology
  RSpec.feature 'Access to the smoke test API', type: :feature do
    let(:data) { { title: 'berserk' } }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }
    let(:name) { 'guts' }
    let(:trace_id) { '74bf7dd481bcc880' }
    let(:count) { 1 }
    let(:links) { {
        self: "http://www.example.com/smoke_test#{parameters}",
        profile: "http://tbd.mdsol.com"
    } }
    let(:items) { [ { name: name }.merge(result.to_hash) ] }
    before do
      FakeSmokeTest.name = name
      FakeSmokeTest.result = result
      FakeSmokeTest.tags = ['runtime']

      FakeSmokeTest2.name = 'fake2'
      FakeSmokeTest2.result = result
      FakeSmokeTest2.tags = ['never_execute_this']
    end

    shared_examples_for 'Access the smoke_test URL' do
      scenario 'returns an expected JSON string' do
        visit "/smoke_test#{parameters}"
        expected = {
          _links: links,
          passed: passed,
          count: count,
          trace_id: trace_id,
          items: items
        }.to_json
        expect(page).to have_text(expected)
      end
    end

    context 'with Trace' do
      before do
        stub_const("Trace", double)
        allow(Trace).to receive_message_chain(:id, :trace_id).and_return(trace_id)
      end

      context 'without parameters' do
        let(:parameters) { '' }
        it_behaves_like 'Access the smoke_test URL'
      end
      context 'with parameters to access tests for runtime' do
        let(:parameters) { '?tags=runtime' }
        it_behaves_like 'Access the smoke_test URL'
      end
      context 'with parameters to access tests for deployments' do
        let(:parameters) { '?tags=deployment' }
        let(:count) { 0 }
        let(:items) { [] }
        it_behaves_like 'Access the smoke_test URL'
      end
      context 'with parameters to skip some other test' do
        let(:parameters) { '?skip=junk,ne' }
        it_behaves_like 'Access the smoke_test URL'
      end
      context 'with parameters to skip our test' do
        let(:parameters) { '?skip=junk,guts' }
        let(:count) { 0 }
        let(:items) { [] }
        it_behaves_like 'Access the smoke_test URL'
      end
    end

    context 'without Trace' do
      let(:trace_id) { nil }
      let(:parameters) { '' }
      it_behaves_like 'Access the smoke_test URL'
    end
  end
end

require 'spec_helper'

module Kapnismology
  RSpec.feature 'Access to the smoke test API' do
    let(:data) { { title: 'berserk' } }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }
    let(:name) { 'guts' }
    let(:trace_id) { '74bf7dd481bcc880' }
    let(:codebase_revision) { '781aab' }
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
          codebase_revision: codebase_revision,
          duration: 0,
          items: items
        }.to_json
        expect(page).to have_text(expected)
      end
    end

    context 'with all the information', :requires_rails do
      before do
        allow_any_instance_of(ApplicationInformation).to receive(:trace_id).and_return(trace_id)
        allow_any_instance_of(ApplicationInformation).to receive(:codebase_revision).and_return(codebase_revision)
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

  end
end

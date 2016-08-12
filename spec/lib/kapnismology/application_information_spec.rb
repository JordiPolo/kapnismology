require 'spec_helper'

module Kapnismology
  RSpec.describe ApplicationInformation do
    let(:result) { described_class.new.result }

    context 'with trace id information' do
      let(:trace_id) { '74bf7dd481bcc880' }
      before do
        stub_const("Trace", double)
        allow(Trace).to receive_message_chain(:id, :trace_id).and_return(trace_id)
      end

      it '#trace_id provides the current trace id' do
        expect(described_class.new.trace_id).to eq(trace_id)
      end
    end

    context 'without trace id information' do
      it '#trace_id provides the current trace id' do
        expect(described_class.new.trace_id).to eq('')
      end
    end

    context 'The app has git information' do
      let(:git_sha) { '336f2eb' }
      let(:git_last_commit) { "336f2eb Merge pull request #7 from JordiPolo/feature/no_colors" }
      before do
        allow_any_instance_of(described_class).to receive('latest_commit_info').and_return(git_last_commit)
      end

      it '#codebase_revision provides the info of the current commit' do
        expect(described_class.new.codebase_revision).to eq(git_sha)
      end
    end

    context 'The app does not have git information' do
      let(:git_last_commit) { "" }
      before do
        allow_any_instance_of(described_class).to receive('latest_commit_info').and_return(git_last_commit)
      end

      it '#codebase_revision provides the info of the current commit' do
        expect(described_class.new.codebase_revision).to eq('')
      end
    end

  end
end

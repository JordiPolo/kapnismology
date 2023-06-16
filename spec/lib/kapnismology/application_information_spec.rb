require 'spec_helper'

module Kapnismology
  RSpec.describe ApplicationInformation do
    before do
      described_class.instance_variable_set(:@singleton__instance__, nil)
    end

    context 'The app has git information' do
      let(:git_sha) { '336f2eb' }

      before do
        stub_const("#{described_class}::GIT_COMMAND", "echo '#{git_sha}'")
      end

      it '#codebase_revision provides the info of the current commit' do
        expect(described_class.instance.codebase_revision).to eq(git_sha)
      end
    end

    context "The app has ECS metadata" do
      let(:metadata_file_location) { File.join(__dir__, "..", "..", "support", "ecs_metadata.json") }
      let(:git_sha) { "aa6eadd" }

      before do
        stub_const("#{described_class}::GIT_COMMAND", "exit 128")
        stub_const("#{described_class}::ECS_CONTAINER_METADATA_FILE", metadata_file_location)
      end

      it '#codebase_revision provides the info of the current commit' do
        expect(described_class.instance.codebase_revision).to eq(git_sha)
      end

      it 'rescues JSON::ParserError when reading the ECS metadata file' do
        allow(File).to receive(:read).with(metadata_file_location).and_return('{not json')
        expect(described_class.instance.codebase_revision).to eq('')
      end
    end

    context "The app has kubernetes annotations" do
      let(:annotations_file_location) { File.join(__dir__, "..", "..", "support", "k8s_annotations") }
      let(:git_sha) { "10f7361" }

      before do
        stub_const("#{described_class}::GIT_COMMAND", "exit 128")
        stub_const("#{described_class}::KUBERNETES_ANNOTATIONS_FILE", annotations_file_location)
      end

      it '#codebase_revision provides the info of the current commit' do
        expect(described_class.instance.codebase_revision).to eq(git_sha)
      end
    end

    context 'The app does not have git information' do
      before do
        stub_const("#{described_class}::GIT_COMMAND", "exit 128")
        stub_const("#{described_class}::ECS_CONTAINER_METADATA_FILE", nil)
      end

      it '#codebase_revision provides the info of the current commit' do
        expect(described_class.instance.codebase_revision).to eq('')
      end
    end
  end
end

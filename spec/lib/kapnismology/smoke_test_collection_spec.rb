require 'spec_helper'

RSpec.describe Kapnismology::SmokeTestCollection do
  class DBSmokeTest
    def self.tags
      %w(deployment runtime)
    end
  end
  class JobSmokeTest
    def self.tags
      ['runtime']
    end
  end
  class InexistentClass; end

  let(:smoketest_classes) { [DBSmokeTest, JobSmokeTest] }
  let(:blacklist) { [] }
  before do
    allow(described_class).to receive(:smoke_tests).and_return(smoketest_classes)
  end

  context 'All tags are allowed' do
    let(:tags) { %w(deployment runtime) }
    context 'blacklist does not contain any class in the smoke test list' do
      let(:blacklist) { [InexistentClass] }
      it 'creates a collection with all the classes' do
        expect(Kapnismology::EvaluationCollection).to receive(:new).with(smoketest_classes)
        described_class.evaluations(tags, blacklist)
      end
    end

    context 'blacklist contain classes from the list of smoke test' do
      let(:blacklist) { ['DBSmokeTest'] }
      it 'creates a collection without the blacklisted classes' do
        expect(Kapnismology::EvaluationCollection).to receive(:new).with([JobSmokeTest])
        described_class.evaluations(tags, blacklist)
      end
    end
  end

  context 'only deployment classes are allowed' do
    let(:tags) { ['deployment'] }
    it 'creates a collection without the classes which do not have deployment' do
      expect(Kapnismology::EvaluationCollection).to receive(:new).with([DBSmokeTest])
      described_class.evaluations(tags, blacklist)
    end
  end

  context 'No tag is allowed to run' do
    let(:tags) { [] }
    it 'creates an empty collection' do
      expect(Kapnismology::EvaluationCollection).to receive(:new).with([])
      described_class.evaluations(tags, blacklist)
    end
  end
end

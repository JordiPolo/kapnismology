require 'spec_helper'

RSpec.describe Kapnismology::SmokeTest do
  let(:smoke_test) { described_class.new }
  it 'has default tags' do
    expect(described_class.tags).to eq(%w(deployment runtime))
  end

  it 'adds arbitrary extra messages to output' do
    smoke_test.send(:puts_to_result, 'This is')
    smoke_test.send(:puts_to_result, 'that was')
    expect(smoke_test.__result__.to_hash[:extra_messages]).to eq(['This is', 'that was'])
  end
end

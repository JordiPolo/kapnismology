require 'spec_helper'

RSpec.describe Kapnismology::Result do
  let(:data) { [:berserk] }
  let(:passed) { true }
  let(:message) { '黄金時代' }
  let(:name) { 'Kentaro Miura' }
  let(:result) { described_class.new(passed, data, message) }
  let(:extra_char) { '' }

  shared_examples_for 'serializes its data' do
    it 'creates a string with its data' do
      expected = "\e[32m\e[1mpassed\e[0m: #{name}\n#{extra_messages.join("\n")}#{extra_char}\e[1m#{message}\e[0m\n   #{data}\n"
      expect(result.to_s(name)).to eq(expected)
    end

    it 'creates a hash with its data' do
      expected = { passed: passed, data: data, message: message, extra_messages: extra_messages }
      expect(result.to_hash).to eq(expected)
    end
  end

  it 'inherits from BaseResult' do
    expect(result.is_a?(Kapnismology::BaseResult)).to eq(true)
  end

  context 'no extra messages added' do
    let(:extra_messages) { [] }
    it_behaves_like 'serializes its data'
  end

  context 'added some extra messages' do
    let(:extra_messages) { %w(42 41) }
    let(:extra_char) { "\n" }

    before do
      result.add_extra_messages(%w(42 41))
    end
    it_behaves_like 'serializes its data'
  end
end

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
      first = "\e[#{terminal_color}m\e[1m#{title}\e[0m: #{name}"
      expected = "#{first}\n#{extra_messages.join("\n")}#{extra_char}\e[1m#{message}\e[0m\n   #{data}\n"
      expect(result.to_s(name)).to eq(expected)
    end

    it 'creates a hash with its data' do
      expected = { passed: passed, data: data, message: message, extra_messages: extra_messages }
      expect(result.to_hash).to eq(expected)
    end
  end

  it 'only allows boolean as first parameter' do
    expect { described_class.new('noop', data, message) }
      .to raise_error(ArgumentError, 'passed argument must be true or false')
  end

  it 'provides access to passed status' do
    expect(result.passed?).to eq(passed)
  end

  describe 'output' do
    context 'check passed' do
      let(:title) { 'passed' }
      let(:terminal_color) { '32' }

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

    context 'check failed' do
      let(:passed) { false }
      let(:title) { 'failed' }
      let(:terminal_color) { '31' }

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

  end
end


RSpec.describe Kapnismology::Success do
  let(:data) { [:berserk] }
  let(:passed) { true }
  let(:message) { '黄金時代' }
  let(:name) { 'Kentaro Miura' }
  let(:result) { described_class.new(data, message) }

  it 'creates a result which has passed the test' do
    expect(result.passed?).to eq(true)
    expect(result.data).to eq(data)
    expect(result.message).to eq(message)
  end
end

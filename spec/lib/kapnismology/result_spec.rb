require 'spec_helper'

RSpec.describe Kapnismology::Result do
  let(:data) { { title: 'berserk' } }
  let(:passed) { true }
  let(:message) { '黄金時代' }
  let(:name) { 'Kentaro Miura' }
  let(:result) { described_class.new(passed, data, message) }
  let(:extra_char) { '' }

  before { allow($stdout).to receive(:isatty).and_return(true) }

  shared_examples_for 'serializes its data' do
    it 'creates a string with its data' do
      first = "\e[#{terminal_color}m\e[1m#{title}\e[0m: #{name}\nduration: \e[1m0\e[0m ms"
      expected = "#{first}\n#{debug_messages.join("\n")}#{extra_char}\e[1m#{message}\e[0m\n   #{data}\n"
      expect(result.to_s(name)).to eq(expected)
    end

    it 'creates a hash with its data' do
      expected = { passed: passed, data: data, message: message, debug_messages: debug_messages, duration: 0 }
      expect(result.to_hash).to eq(expected)
    end
  end

  it 'only allows boolean as first parameter' do
    expect { described_class.new('noop', data, message) }
      .to raise_error(ArgumentError, 'passed argument must be true or false')
  end

  it 'only allows hash as data parameter' do
    expect { described_class.new(passed, [data], message) }
      .to raise_error(ArgumentError, 'data argument must be a hash')
  end

  it 'provides access to passed status' do
    expect(result.passed?).to eq(passed)
  end

  describe 'record_duration' do
    before do
      Timecop.freeze
    end

    it 'records duration of the test' do
      result.record_duration(Time.now - 1)
      expect(result.duration).to eq(1000)
    end
  end

  describe 'output' do
    context 'check passed' do
      let(:title) { 'passed' }
      let(:terminal_color) { '32' }

      context 'no extra messages added' do
        let(:debug_messages) { [] }
        it_behaves_like 'serializes its data'
      end

      context 'added some extra messages' do
        let(:debug_messages) { %w[42 41] }
        let(:extra_char) { "\n" }

        before do
          result.add_debug_messages(%w[42 41])
        end
        it_behaves_like 'serializes its data'
      end
    end

    context 'check failed' do
      let(:passed) { false }
      let(:title) { 'failed' }
      let(:terminal_color) { '31' }

      context 'no extra messages added' do
        let(:debug_messages) { [] }
        it_behaves_like 'serializes its data'
      end

      context 'added some extra messages' do
        let(:debug_messages) { %w[42 41] }
        let(:extra_char) { "\n" }

        before do
          result.add_debug_messages(%w[42 41])
        end
        it_behaves_like 'serializes its data'
      end
    end
  end
end

RSpec.describe Kapnismology::Success do
  let(:data) { { title: 'berserk' } }
  let(:passed) { true }
  let(:message) { '黄金時代' }
  let(:name) { 'Kentaro Miura' }
  let(:result) { described_class.new(data, message) }

  it 'creates a result which has passed the test' do
    expect(result.passed?).to eq(true)
    expect(result.data).to eq(data)
    expect(result.message).to eq(message)
  end

  it 'only allows hash as data parameter' do
    expect { described_class.new([data], message) }
      .to raise_error(ArgumentError, 'data argument must be a hash')
  end
end

RSpec.describe Kapnismology::NullResult do
  let(:data) { { version: 'newest' } }
  let(:message) { 'This check just provides info about the version' }
  let(:name) { 'Skynet' }

  let(:result) { described_class.new(data, message) }

  before { allow($stdout).to receive(:isatty).and_return(true) }

  it "#{described_class} creates a result which has passed the test" do
    expect(result.passed?).to eq(true)
    expect(result.data).to eq(data)
    expect(result.message).to eq(message)
  end

  it "#{described_class}#to_hash returns nil" do
    hash = result.to_hash
    expect(hash).to eq({})
  end

  it "#{described_class}#to_s shows a skipped check" do
    first = "\e[33m\e[1mThis test can not be run. Skipping...\e[0m\n\e[33m\e[1mSkipped\e[0m: #{name}\nduration: \e[1m0\e[0m ms"
    expected = "#{first}\n#{[].join("\n")}\e[1m#{message}\e[0m\n   #{data}\n"
    expect(result.to_s(name)).to eq(expected)
  end
end

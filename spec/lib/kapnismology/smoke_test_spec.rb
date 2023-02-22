require 'spec_helper'

RSpec.describe Kapnismology::SmokeTest do
  let(:smoke_test) { described_class.new }

  def expect_failed(data, message, debug_messages = [])
    result = smoke_test.__result__
    expect(result.passed?).to eq(false)
    expect(result.data).to eq(data)
    expect(result.message).to eq(message)
    expect(result.debug_messages).to eq(debug_messages)
  end

  it 'has default tags' do
    expect(described_class.tags).to eq(%w[deployment runtime])
  end

  it 'has default timeout of 10' do
    expect(described_class.timeout).to eq(10)
  end

  it 'adds arbitrary extra messages to output' do
    smoke_test.send(:puts_to_result, 'This is')
    smoke_test.send(:puts_to_result, 'that was')
    expect(smoke_test.__result__.to_hash[:debug_messages]).to eq(['This is', 'that was'])
  end

  context 'smoke test returns an empty result' do
    it 'reports a failed result' do
      expect_failed({}, 'This test has not returned any result')
    end
  end

  context 'smoke test returns a class that is not a result' do
    before do
      allow(smoke_test).to receive(:result).and_return('pass')
    end
    it 'reports a failed result' do
      message = 'Smoke test Kapnismology::SmokeTest, returned String instead of a Result'
      expect_failed({ returned_class: String }, message)
    end
  end

  context 'smoke test times out' do
    before do
      allow(Timeout).to receive(:timeout).with(described_class.timeout).and_raise(Timeout::Error)
    end
    it 'reports a failed result' do
      message = 'Kapnismology::SmokeTest took more than 10 seconds to finish and timed-out'
      expect_failed({ exception: Timeout::Error, message: "Timeout::Error" }, message)
    end
  end

  context 'smoke test raises Timeout::Error internally' do
    before do
      allow(smoke_test).to receive(:result).and_raise(Timeout::Error)
    end
    it 'reports a failed result' do
      message = 'Kapnismology::SmokeTest took more than 10 seconds to finish and timed-out'
      expect_failed({ exception: Timeout::Error, message: "Timeout::Error" }, message)
    end
  end

  context 'smoke test raises Kapnismology::SmokeTestFailed' do
    let(:exception_data) { { data: 4 } }
    let(:exception_message) { 'Smoke test failed big time' }
    before do
      exception = Kapnismology::SmokeTestFailed.new(exception_data, exception_message)
      allow(smoke_test).to receive(:result).and_raise(exception)
    end
    it 'reports a failed result' do
      expect_failed(exception_data, exception_message)
    end
  end

  context 'smoke test raises Kapnismology::SmokeTest::SmokeTestFailed' do
    let(:exception_data) { { data: 4 } }
    let(:exception_message) { 'Smoke test failed big time' }
    before do
      exception = Kapnismology::SmokeTest::SmokeTestFailed.new(exception_data, exception_message)
      allow(smoke_test).to receive(:result).and_raise(exception)
    end
    it 'reports a failed result' do
      expect_failed(exception_data, exception_message)
    end
  end

  context 'smoke test raises any other exception' do
    before do
      allow(smoke_test).to receive(:result).and_raise(Errno::EHOSTUNREACH)
    end
    it 'reports a failed result' do
      message = 'Unrescued error happened in Kapnismology::SmokeTest'
      expect_failed({ exception: Errno::EHOSTUNREACH, message: "No route to host" }, message)
    end
  end

  context 'smoke test adds extra information to a failing error' do
    before do
      smoke_test.send(:puts_to_result, 'Some extra information')
      allow(smoke_test).to receive(:result).and_raise(Errno::EHOSTUNREACH)
    end
    it 'reports a failed result with extra information' do
      message = 'Unrescued error happened in Kapnismology::SmokeTest'
      expect_failed({ exception: Errno::EHOSTUNREACH, message: "No route to host" }, message,
        ["Some extra information"])
    end
  end
end

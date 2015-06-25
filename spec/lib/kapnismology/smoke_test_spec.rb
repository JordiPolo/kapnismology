require 'spec_helper'
require 'byebug'

RSpec.describe Kapnismology::SmokeTest do
  describe '#result' do
    it 'retuns an empty hash when there is no information' do
      byebug
      expect(Kapnismology::SmokeTest.result).to eq({})
    end
  end
end
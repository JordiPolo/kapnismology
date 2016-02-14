require 'spec_helper'

module Kapnismology
  RSpec.feature 'everything in its right place', type: :feature do
    let(:data) { [:berserk] }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }
    let(:name) { 'guts' }
    before do
      FakeSmokeTest.name = name
      FakeSmokeTest.result = result
    end
    scenario 'User creates a new widget' do
      visit '/smoke_test'
      expected = '[{"guts":{"passed":true,"data":["berserk"],"message":"黄金時代"}}]'
      expect(page).to have_text(expected)
    end
  end
end

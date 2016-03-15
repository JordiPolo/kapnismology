require 'spec_helper'

module Kapnismology
  RSpec.feature 'Access to the smoke test API', type: :feature do
    let(:data) { [:berserk] }
    let(:passed) { true }
    let(:message) { '黄金時代' }
    let(:result) { Result.new(passed, data, message) }
    let(:name) { 'guts' }
    before do
      FakeSmokeTest.name = name
      FakeSmokeTest.result = result
      FakeSmokeTest.tags = ['runtime']

      FakeSmokeTest2.name = 'fake2'
      FakeSmokeTest2.result = result
      FakeSmokeTest2.tags = ['never_execute_this']
    end
    scenario 'Access the smoke_test URL without parameters' do
      visit '/smoke_test'
      expected = '[{"guts":{"passed":true,"data":["berserk"],"message":"黄金時代","extra_messages":[]}}]'
      expect(page).to have_text(expected)
    end
    scenario 'Access the smoke_test URL with parameters to access tests for runtime' do
      visit '/smoke_test?tags=runtime'
      expected = '[{"guts":{"passed":true,"data":["berserk"],"message":"黄金時代","extra_messages":[]}}]'
      expect(page).to have_text(expected)
    end
    scenario 'Access the smoke_test URL with parameters to access tests for deployments' do
      visit '/smoke_test?tags=deployment'
      expected = '[]'
      expect(page).to have_text(expected)
    end
    scenario 'Access the smoke_test URL with parameters to skip some other test' do
      visit '/smoke_test?skip=junk,ne'
      expected = '[{"guts":{"passed":true,"data":["berserk"],"message":"黄金時代","extra_messages":[]}}]'
      expect(page).to have_text(expected)
    end
    scenario 'Access the smoke_test URL with parameters to skip our test' do
      visit '/smoke_test?skip=junk,guts'
      expected = '[]'
      expect(page).to have_text(expected)
    end
  end
end

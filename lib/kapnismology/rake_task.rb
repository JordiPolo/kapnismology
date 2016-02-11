module Kapnismology
  class RakeTask
    def output
      evaluations = SmokeTest.evaluations
      evaluations.each do |evaluation|
        puts evaluation.to_s
        puts
      end
      fail 'We have some failures in our smoke tests' unless evaluations.passed?
    end
  end
end
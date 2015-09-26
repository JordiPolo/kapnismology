module Kapnismology
  class RakeTask
    def output
      evaluations = SmokeTest.evaluations
      evaluations.each do |evaluation|
        puts "The smoke test #{evaluation.test_name} #{passed_or_failed(evaluation.passed)}"
        puts evaluation.message
        puts
      end
      fail 'We have some failures in our smoke tests' unless evaluations.passed?
    end

    def passed_or_failed(passed)
      passed ? "passed" : "failed"
    end
  end
end
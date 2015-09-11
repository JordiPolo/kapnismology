module Kapnismology
  class RakeTask
    def output
      evaluations = SmokeTest.result
      evaluations.each do |evaluation|
        puts "The smoke test #{evaluation.test_name} #{passed_or_failed(evaluation.passed)}"
        puts evaluation.message
        puts
      end
      all_passed = evaluations.map(&:passed).inject{|m, result| m && result}
      fail 'We have some failures in our smoke tests' unless all_passed
    end

    def passed_or_failed(passed)
      passed ? "passed" : "failed"
    end
  end
end
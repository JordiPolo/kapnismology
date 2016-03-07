require 'kapnismology/terminal'
module Kapnismology
  class RakeTask
    def output
      evaluations = SmokeTestCollection.evaluations
      puts
      puts
      evaluations.each do |evaluation|
        puts evaluation.to_s
        puts
      end
      if evaluations.passed?
        puts Terminal.green('All smoke tests passed successfully!')
      else
        abort Terminal.red('We have some failures in our smoke tests')
      end
    end
  end
end

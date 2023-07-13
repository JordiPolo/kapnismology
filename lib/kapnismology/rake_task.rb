require 'kapnismology/terminal'
module Kapnismology
  class RakeTask
    def output(allowed_tags = [SmokeTest::RUNTIME_TAG], blacklist = [])
      puts "Running smoke test for codebase revision #{ApplicationInformation.instance.codebase_revision}"
      evaluations = SmokeTestCollection.evaluations(allowed_tags, blacklist)
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

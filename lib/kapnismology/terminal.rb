module Kapnismology
  class Terminal
    def self.green(msg)
      "\e[32m\e[1m#{msg}\e[0m"
    end

    def self.red(msg)
      "\e[31m\e[1m#{msg}\e[0m"
    end

    def self.bold(msg)
      "\e[1m#{msg}\e[0m"
    end
  end
end

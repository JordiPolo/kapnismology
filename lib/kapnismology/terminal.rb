module Kapnismology
  class Terminal
    def self.green(msg)
      colorize(msg, "\e[32m")
    end

    def self.red(msg)
      colorize(msg, "\e[31m")
    end

    def self.yellow(msg)
      colorize(msg, "\e[33m")
    end

    def self.bold(msg)
      colorize(msg, '')
    end

    def self.colorize(msg, color_code)
      # \e[1m adds bold font, \e[0m resets all styles
      $stdout.isatty ? "#{color_code}\e[1m#{msg}\e[0m" : msg
    end
  end
end

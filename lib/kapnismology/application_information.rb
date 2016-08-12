module Kapnismology
  # This class provides information about the running environment the smoketest is being
  # executed under.
  class ApplicationInformation
    INFO_UNKNOWN = ''

    def trace_id
      Object.const_defined?(:Trace) ? Trace.id.trace_id.to_s : INFO_UNKNOWN
    end

    def codebase_revision
      latest_commit_info.split(/\s/).first || INFO_UNKNOWN
    rescue Errno::ENOENT, StandardError
     INFO_UNKNOWN
    end

    private
    def latest_commit_info
      `git show HEAD --abbrev-commit --oneline`
    end
  end
end

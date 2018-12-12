require "json"

module Kapnismology
  # This class provides information about the running environment the smoketest is being
  # executed under.
  class ApplicationInformation
    GIT_SHOW_COMMAND = "git show HEAD --abbrev-commit --oneline".freeze
    ECS_CONTAINER_METADATA_FILE = ENV["ECS_CONTAINER_METADATA_FILE"].freeze
    INFO_UNKNOWN = ""

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
      latest_ref_from_git || latest_ref_from_ecs_metadata || nil
    end

    def latest_ref_from_git
      result = `#{GIT_SHOW_COMMAND}`
      $?.success? ? result : nil
    end

    # This assumes the ImageName features the git ref as the last part of a string delimited by dots.
    # See spec/support/ecs_metadata.json as well as
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-metadata.html
    def latest_ref_from_ecs_metadata
      return unless !ECS_CONTAINER_METADATA_FILE&.strip.empty? && File.readable?(ECS_CONTAINER_METADATA_FILE)
      begin
        JSON.parse(File.read(ECS_CONTAINER_METADATA_FILE))["ImageName"].split(".").last[0...7]
      rescue JSON::ParserError
        nil
      end
    end
  end
end

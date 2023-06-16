require "json"
require "singleton"

module Kapnismology
  # This class provides information about the running environment the smoketest is being
  # executed under.
  class ApplicationInformation
    include Singleton

    GIT_COMMAND = "git rev-parse --short HEAD 2>/dev/null".freeze
    ECS_CONTAINER_METADATA_FILE = ENV["ECS_CONTAINER_METADATA_FILE"].freeze
    KUBERNETES_ANNOTATIONS_FILE = "/etc/podinfo/annotations".freeze
    INFO_UNKNOWN = "".freeze

    def codebase_revision
      @codebase_revision ||= begin
        latest_commit_info[0...7]
      rescue Errno::ENOENT, StandardError
        INFO_UNKNOWN
      end
    end

    private

    def latest_commit_info
      latest_sha_from_ecs_metadata || latest_sha_from_k8s_annotations || latest_sha_from_git || INFO_UNKNOWN
    end

    def latest_sha_from_git
      result = `#{GIT_COMMAND}`
      $?.success? ? result : nil
    end

    # This assumes the ImageName features the git sha as the last part of a string delimited by dots.
    # See spec/support/ecs_metadata.json as well as
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/container-metadata.html
    def latest_sha_from_ecs_metadata
      return nil if ECS_CONTAINER_METADATA_FILE.nil?
      return nil unless !ECS_CONTAINER_METADATA_FILE.strip.empty? && File.readable?(ECS_CONTAINER_METADATA_FILE)

      begin
        JSON.parse(File.read(ECS_CONTAINER_METADATA_FILE))["ImageName"].split(".").last
      rescue JSON::ParserError
        nil
      end
    end

    def latest_sha_from_k8s_annotations
      return nil unless File.readable?(KUBERNETES_ANNOTATIONS_FILE)

      File.read(KUBERNETES_ANNOTATIONS_FILE).scan(/gitSha="(.+)"$/).last&.first
    end
  end
end

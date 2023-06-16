module Kapnismology
  # A summary of a run containing smoke test evaluations
  class SmokeTestResponse
    PROFILE_URL = 'http://tbd.mdsol.com'.freeze

    def initialize(evaluations)
      @evaluations = evaluations
    end

    def status
      @evaluations.passed? ? 200 : 503
    end

    def render(request_url)
      items = @evaluations.to_hash.select { |e| e.has_key?(:passed) }
      {
        _links: {
          self: CGI.unescape(request_url),
          profile: PROFILE_URL
        },
        passed: @evaluations.passed?,
        count: items.size,
        codebase_revision: ApplicationInformation.instance.codebase_revision,
        duration: @evaluations.total_duration,
        items: items
      }.to_json
    end
  end
end

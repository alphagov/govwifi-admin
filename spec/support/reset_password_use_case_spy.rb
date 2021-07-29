# rubocop:disable Style/ClassVars
class ResetPasswordUseCaseSpy
  @@last_reset_url = nil
  @@reset_count = 0

  class << self
    def last_reset_url
      @@last_reset_url
    end

    def last_reset_path_with_query
      url_obj = URI.parse(last_reset_url)
      "#{url_obj.path}?#{url_obj.query}"
    end

    def reset_count
      @@reset_count
    end

    def clear!
      @@last_reset_url = nil
      @@reset_count = 0
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def execute(email:, reset_url:, template_id:)
    @@last_reset_url = reset_url
    @@reset_count += 1

    {}
  end
  # rubocop:enable Lint/UnusedMethodArgument
end
# rubocop:enable Style/ClassVars

# rubocop:disable Style/ClassVars
class MembershipInviteUseCaseSpy
  @@last_invite_url = nil
  @@invite_count = 0

  class << self
    def last_invite_url
      @@last_invite_url
    end

    def invite_count
      @@invite_count
    end

    def clear!
      @@last_invite_url = nil
      @@invite_count = 0
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def execute(email:, invite_url:, template_id:, organisation:)
    @@last_invite_url = invite_url
    @@invite_count += 1

    {}
  end
  # rubocop:enable Lint/UnusedMethodArgument
end
# rubocop:enable Style/ClassVars

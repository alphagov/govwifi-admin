shared_context 'when unlocking an account' do
  before do
    allow(UseCases::Administrator::SendUnlockEmail).to \
      receive(:new).and_return(UnlockAccountUseCaseSpy.new)
  end

  after do
    UnlockAccountUseCaseSpy.clear!
  end
end

# rubocop:disable Style/ClassVars
class UnlockAccountUseCaseSpy
  @@last_unlock_url = nil
  @@unlock_count = 0

  class << self
    def last_unlock_url
      @@last_unlock_url
    end

    def last_unlock_path_with_query
      url_obj = URI.parse(last_unlock_url)
      url_obj.path + "?" + url_obj.query
    end

    def unlock_count
      @@unlock_count
    end

    def clear!
      @@last_unlock_url = nil
      @@unlock_count = 0
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def execute(email:, unlock_url:, template_id:)
    @@last_unlock_url = unlock_url
    @@unlock_count += 1

    {}
  end
  # rubocop:enable Lint/UnusedMethodArgument
end
# rubocop:enable Style/ClassVars

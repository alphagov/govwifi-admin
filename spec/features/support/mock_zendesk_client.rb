shared_context 'with a mocked support tickets client' do
  class ZendeskClientMock
    class << self
      attr_accessor :config
    end

    def initialize
      raise ArgumentError, "block not given" unless block_given?

      self.class.config = double(:url, :username, :token)
      yield self.class.config
    end

    def self.reset!
      # probably need something like this
    end
  end

  before { stub_const("ZendeskAPI::Client", ZendeskClientMock) }
  after { ZendeskClientMock.reset! }

  let(:support_tickets) { [] }
  let(:support_ticket_url) { ZendeskClientMock.config&.url }
  let(:support_ticket_credentials) do
    {
      username: ZendeskClientMock.config&.username,
      token: ZendeskClientMock.config&.token
    }
  end
end

shared_context 'with a mocked support tickets client' do
  class ZendeskClientMock
    class << self
      attr_accessor :config
      attr_accessor :support_tickets
    end

    def initialize
      raise ArgumentError, "block not given" unless block_given?
      yield self.class.config
    end

    def self.reset!
      self.support_tickets = []
      self.config = Struct.new(:url, :username, :token).new
    end

    def tickets
      # I'm lazy, this could be a separate mock
      self
    end

    def create!(subject: nil, requester: nil, comment: nil)
      self.class.support_tickets << {
        subject: subject,
        requester: requester,
        comment: comment
      }
    end
  end

  before do
    stub_const("ZendeskAPI::Client", ZendeskClientMock)
    ZendeskClientMock.reset!
  end

  let(:support_tickets) { ZendeskClientMock.support_tickets }
  let(:support_ticket_url) { ZendeskClientMock.config.url }
  let(:support_ticket_credentials) do
    {
      username: ZendeskClientMock.config&.username,
      token: ZendeskClientMock.config&.token
    }
  end
end

shared_context "with a mocked support tickets client" do
  class ZendeskClientMock       # rubocop:disable Lint/ConstantDefinitionInBlock
    class << self
      attr_accessor :config, :support_tickets, :exception_to_raise
    end

    def initialize
      raise ArgumentError, "block not given" unless block_given?

      yield self.class.config
    end

    def self.reset!
      self.support_tickets = []
      self.config = Struct.new(:url, :username, :token).new
      self.exception_to_raise = nil
    end

    def tickets
      # I'm lazy, this could be a separate mock
      self
    end

    def create!(subject: nil, requester: nil, comment: nil, tags: nil)
      raise self.class.exception_to_raise unless self.class.exception_to_raise.nil?

      self.class.support_tickets << {
        subject:,
        requester:,
        comment:,
        tags:,
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
      token: ZendeskClientMock.config&.token,
    }
  end
end

shared_context 'with a mocked notifications client' do
  class NotificationsMock
    class << self
      attr_accessor :notifications
    end

    def initialize(_unused)
      self.class.notifications ||= []
    end

    # TODO: remove dependency on test entries in gov-notify.yml
    def send_email(args)
      self.class.notifications << args[:template_id]
    end

    def self.reset!
      @notifications = []
    end
  end

  before { stub_const("Notifications::Client", NotificationsMock) }
  after { NotificationsMock.reset! }

  let(:notifications) { NotificationsMock.notifications }
end

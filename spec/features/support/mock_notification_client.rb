shared_context "with a mocked notifications client" do
  class NotificationsMock # rubocop:disable Lint/ConstantDefinitionInBlock
    class << self
      attr_accessor :notifications
    end

    def initialize(_unused)
      self.class.notifications ||= []
    end

    # TODO: remove dependency on test entries in gov-notify.yml
    def send_email(args)
      self.class.notifications << {
        type: args[:template_id],
        link: find_link(args),
        personalisation: args[:personalisation],
      }
    end

    def find_link(args)
      invite_url = args.dig(:personalisation, :invite_url)
      reset_url = args.dig(:personalisation, :reset_url)
      confirmation_url = args.dig(:personalisation, :confirmation_url)
      unlock_url = args.dig(:personalisation, :unlock_url)

      reset_url || invite_url || confirmation_url || unlock_url
    end

    def self.reset!
      @notifications = []
    end
  end

  before { stub_const("Notifications::Client", NotificationsMock) }

  after { NotificationsMock.reset! }

  let(:notifications) { NotificationsMock.notifications }
  let(:last_notification_type) { NotificationsMock.notifications.last[:type] }
  let(:last_notification_link) { NotificationsMock.notifications.last[:link] }
  let(:last_notification_personalisation) do
    NotificationsMock.notifications.last[:personalisation]
  end
end

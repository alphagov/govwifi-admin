describe UseCases::Administrator::SendInviteEmail do
  subject(:use_case) { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { instance_spy("EmailGateway", send: nil) }
  let(:email) { "test@example.com" }
  let(:invite_url) { "https://example.com" }
  let(:template_id) { GOV_NOTIFY_CONFIG["invite_email"]["template_id"] }
  let(:valid_args) do
    {
      email:,
      email_reply_to_id: nil,
      locals: { invite_url: },
      template_id:,
      reference: "invite_email",
    }
  end

  before do
    use_case.execute(
      email:,
      invite_url:,
      template_id:,
    )
  end

  it "calls notifications gateway with valid data" do
    expect(gateway_spy).to have_received(:send).with(valid_args)
  end
end

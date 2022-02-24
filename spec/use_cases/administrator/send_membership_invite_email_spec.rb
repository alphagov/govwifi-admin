describe UseCases::Administrator::SendMembershipInviteEmail do
  subject(:use_case) { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { instance_spy("EmailGateway", send: nil) }
  let(:email) { "test@example.com" }
  let(:invite_url) { "https://example.com" }
  let(:template_id) { GOV_NOTIFY_CONFIG["cross_organisation_invitation"]["template_id"] }
  let(:organisation) { create(:organisation) }
  let(:valid_args) do
    {
      email:,
      email_reply_to_id: nil,
      locals: {
        invite_url:,
        organisation: organisation.name,
      },
      template_id:,
      reference: "invite_email",
    }
  end

  before do
    use_case.execute(
      email:,
      invite_url:,
      template_id:,
      organisation:,
    )
  end

  it "calls notifications gateway with valid data" do
    expect(gateway_spy).to have_received(:send).with(valid_args)
  end
end

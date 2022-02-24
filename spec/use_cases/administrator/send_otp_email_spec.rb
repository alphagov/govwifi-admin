describe UseCases::Administrator::SendOtpEmail do
  subject(:use_case) { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { instance_spy("EmailGateway", send: nil) }
  let(:email_address) { "test@example.com" }
  let(:url) { "https://example.com?totp=something" }
  let(:template_id) { GOV_NOTIFY_CONFIG["otp_email"]["template_id"] }
  let(:valid_args) do
    {
      email: email_address,
      email_reply_to_id: nil,
      locals: { url:, name: "test_name" },
      template_id:,
      reference: "otp_email",
    }
  end

  before do
    use_case.execute(
      name: "test_name",
      email_address:,
      url:,
    )
  end

  it "calls notifications gateway with valid data" do
    expect(gateway_spy).to have_received(:send).with(valid_args)
  end
end

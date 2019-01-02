describe UseCases::Administrator::SendHelpEmail do
  subject { described_class.new(notifications_gateway: gateway_spy) }

  let(:gateway_spy) { spy(send: nil) }

  let(:email) { 'example_support@email.com' }
  let(:template_id) { 'aaa-bbb-ccc' }
  let(:details) { 'some problem' }
  let(:name) { 'Mr Example' }
  let(:email_subject) { 'my problem' }
  let(:sender_email) { 'sender@example.com' }
  let(:organisation) { 'Example Organisation' }

  before do
    subject.execute(
      email: email,
      template_id: template_id,
      details: details,
      name: name,
      subject: email_subject,
      sender_email: sender_email,
      organisation: organisation
    )
  end

  let(:expected_locals) do
    {
      details: details,
      subject: email_subject,
      sender_email: sender_email,
      organisation: organisation,
      name: name
    }
  end

  it 'calls notifications gateway with valid data' do
    expect(gateway_spy).to have_received(:send) do |args|
      expect(args[:email]).to eq(email)
      expect(args[:locals]).to eq(expected_locals)
      expect(args[:template_id]).to eq(template_id)
      expect(args[:reference]).to eq('help_email')
    end
  end
end

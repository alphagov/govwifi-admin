class DummyWhitelistPresenter
  def execute(payload)
    payload.join('*')
  end
end

describe UseCases::Administrator::PublishSignupWhitelist do
  let(:source_gateway) { double(fetch_domains: %i(gov.org.uk nhs.uk)) }
  let(:s3_gateway) { double }
  let(:formatted_s3_payload) { 'gov.org.uk*nhs.uk' }
  let(:presenter) { DummyWhitelistPresenter.new }

  it 'publishes the email domain whitelist' do
    expect(s3_gateway).to receive(:write).with(data: formatted_s3_payload)

    described_class.new(
      destination_gateway: s3_gateway,
      source_gateway: source_gateway,
      presenter: presenter
    ).execute
  end
end

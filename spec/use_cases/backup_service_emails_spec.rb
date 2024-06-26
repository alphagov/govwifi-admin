describe UseCases::BackupServiceEmails do
  subject(:use_case) do
    described_class.new(writer:)
  end

  let(:writer) { instance_spy(Gateways::GoogleDrive) }

  let(:test_time) { Time.zone.now }

  before do
    Deploy.env = "test"
    Timecop.freeze(test_time) { use_case.execute }
  end

  it "writes the generated CSV" do
    expect(writer).to have_received(:write)
      .with(
        file_name: "test-#{test_time.strftime('%Y-%m-%d-%H-%M-%S')}.csv",
        folder_name: "GovWifi Service Address Backup",
        upload_source: be_a(StringIO),
        mime_type: "application/csv",
      )
  end
end

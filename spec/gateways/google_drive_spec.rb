describe Gateways::GoogleDrive do
  subject(:gateway) do
    described_class.new(credentials: '{ "foo": "bar" }')
  end

  before do
    allow(Google::Auth::ServiceAccountCredentials).to receive(:make_creds)
    allow_any_instance_of(Google::Apis::DriveV3::DriveService).to receive(:create_file).and_return(OpenStruct.new({ id: 1 }))
    allow_any_instance_of(Google::Apis::DriveV3::DriveService).to receive(:list_files).and_return(OpenStruct.new({ files: [OpenStruct.new({ id: 2 })] }))
    allow_any_instance_of(Google::Apis::DriveV3::DriveService).to receive(:update_file)
  end

  after(:each) do
    gateway.write(
      file_name: "foo",
      folder_name: "bar",
      upload_source: StringIO.new("baz"),
      mime_type: "qux/quux",
    )
  end

  it "calls create_file with the expected args" do
    expect_any_instance_of(Google::Apis::DriveV3::DriveService).to receive(:create_file)
      .with(
        be_a(Google::Apis::DriveV3::File),
        upload_source: be_a(StringIO),
      )
  end

  it "calls update_file with the expected args" do
    expect_any_instance_of(Google::Apis::DriveV3::DriveService).to receive(:update_file)
      .with(
        1,
        nil,
        add_parents: 2,
      )
  end
end

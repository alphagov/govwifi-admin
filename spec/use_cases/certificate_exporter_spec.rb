require "zip"

describe UseCases::CertificateExporter do
  let(:organisation) { create(:organisation, cba_enabled: true) }
  let(:certficate_file_path) do
    zipfile = Tempfile.new("out.zip")
    zipfile.write(Gateways::S3.new(**Gateways::S3::CERTIFICATES).read)
    zipfile.close
    zipfile.path
  end

  it "zips up certificates" do
    create_list(:certificate, 2, organisation:)

    UseCases::CertificateExporter.export

    Zip::File.open(certficate_file_path) do |files|
      expect(files.count).to eq(2)
      expect(files.map { |file| files.read(file) }).to match(Certificate.pluck(:content))
    end
  end

  it "does not zip up certificates with children" do
    root_key = OpenSSL::PKey::RSA.new(512)
    create(:certificate, key: root_key, subject: "/CN=rootca", organisation:)
    intermediate_ca = create(:certificate, issuing_key: root_key, issuing_subject: "/CN=rootca", organisation:)

    UseCases::CertificateExporter.export

    Zip::File.open(certficate_file_path) do |files|
      expect(files.count).to eq(1)
      expect(files.read(files.first)).to eq(intermediate_ca.content)
    end
  end
end

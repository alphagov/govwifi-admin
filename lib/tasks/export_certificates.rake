desc "Export all issuing certificates as a zip file to an S3 bucket to be used by FreeRadius"
task export_certificates: :environment do
  UseCases::CertificateExporter.export
end

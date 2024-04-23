require "openssl"

class CertificateHelper
  def initialize
    @root_key = OpenSSL::PKey::RSA.new 512
    @intermediate_key = OpenSSL::PKey::RSA.new 512
  end

  def root_ca(subject: "/CN=RootCA",
              not_after: Time.zone.now.days_since(365),
              not_before: Time.zone.now.days_ago(1),
              serial: 123)
    certificate = OpenSSL::X509::Certificate.new

    certificate.public_key = @root_key.public_key
    certificate.serial = serial
    certificate.subject = certificate.issuer = OpenSSL::X509::Name.parse(subject)
    certificate.not_before = not_before
    certificate.not_after = not_after
    certificate.extensions = [
      OpenSSL::X509::ExtensionFactory.new.create_extension("basicConstraints", "CA:TRUE", true),
    ]
    certificate.sign @root_key, OpenSSL::Digest.new("SHA1")
    certificate
  end

  def intermediate_ca(signed_by:,
                      subject: "/CN=IntermediateCA",
                      not_after: Time.zone.now + 365 * 24 * 60 * 60,
                      serial: 234)
    certificate = OpenSSL::X509::Certificate.new

    certificate.public_key = @intermediate_key.public_key
    certificate.serial = serial
    certificate.subject = OpenSSL::X509::Name.parse subject
    certificate.issuer = signed_by.subject
    certificate.not_before = Time.zone.now
    certificate.not_after = not_after

    certificate.extensions = [
      OpenSSL::X509::ExtensionFactory.new.create_extension("basicConstraints", "CA:TRUE", true),
    ]
    certificate.sign(@root_key, OpenSSL::Digest.new("SHA256"))
    certificate
  end
end

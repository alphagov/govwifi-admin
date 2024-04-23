require "openssl"
class CertificateForm
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :file, :name, :organisation

  before_validation :parse_certificate

  validate :name_uniqueness, :fingerprint_uniqueness
  validates :name, presence: true
  validates :file, presence: true

  validate :validate_x509

  def save
    return false unless valid?

    !!@certificate&.save
  end

private

  def name_uniqueness
    errors.add(:name, :taken) if Certificate.exists?(organisation:, name:)
  end

  def fingerprint_uniqueness
    return if @certificate.nil?

    errors.add(:file, :taken) if Certificate.exists?(organisation:, fingerprint: @certificate.fingerprint)
  end

  def validate_x509
    return if @x509_parsing_error.nil?

    errors.add(:file, :invalid_certificate)
  end

  def parse_certificate
    content = file&.read
    return if content.nil?

    @certificate = Certificate.new(name:, organisation:)
    @certificate.content = content
    x509_certificate = OpenSSL::X509::Certificate.new(content)
    @certificate.fingerprint = OpenSSL::Digest::SHA1.new(x509_certificate.to_der).to_s
    @certificate.subject = x509_certificate.subject.to_s
    @certificate.issuer = x509_certificate.issuer.to_s
    @certificate.not_before = x509_certificate.not_before
    @certificate.not_after = x509_certificate.not_after
    @certificate.serial = x509_certificate.serial.to_s
  rescue OpenSSL::X509::CertificateError => e
    @x509_parsing_error = e.message
  end
end

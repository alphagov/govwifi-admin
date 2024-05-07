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
    return false if invalid?

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

  def content
    @content ||= file&.read
  end

  def parse_certificate
    @certificate = Certificate.parse_certificate(content)
    @certificate.name = name
    @certificate.organisation = organisation
    @certificate.validate
  rescue OpenSSL::X509::CertificateError => e
    @x509_parsing_error = e.message
  end
end

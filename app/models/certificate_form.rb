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
  validate :validate_has_parent

  def save
    return false if invalid?

    !!@certificate&.save
  end

private

  def name_uniqueness
    return if @certificate.nil?

    errors.add(:name, :taken) if @certificate.errors.of_kind?(:name, :taken)
  end

  def fingerprint_uniqueness
    return if @certificate.nil?

    errors.add(:file, :taken) if @certificate.errors.of_kind?(:fingerprint, :taken)
  end

  def validate_x509
    return if @x509_parsing_error.nil?

    errors.add(:file, :invalid_certificate)
  end

  def validate_has_parent
    errors.add(:file, :no_parent) unless @certificate&.has_parent?
  end

  def content
    @content ||= file&.read
  end

  def parse_certificate
    return if content.nil?

    @certificate = Certificate.parse_certificate(content)
    @certificate.name = name
    @certificate.organisation = organisation
    @certificate.validate
  rescue OpenSSL::X509::CertificateError => e
    @x509_parsing_error = e.message
  end
end

require "openssl"

class Certificate < ApplicationRecord
  belongs_to :organisation
  before_validation :extract_raw_content
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :organisation_id }
  validates :subject, :issuer, :valid_from, :valid_to, :serial_number, :content, presence: true
  # before_validation :parse_x509

  # def parse_x509
  #   result = false
  #   begin
  #     x509 = OpenSSL::X509::Certificate.new(content)
  #     @subject = x509.subject.to_s
  #     @issuer = x509.issuer.to_s
  #     @valid_from = x509.not_before
  #     @valid_to = x509.not_after
  #     @serial_number = x509.serial.to_s(16)
  #     result = true
  #   rescue OpenSSL::X509::CertificateError
  #     errors.add(:content, "Problem reading certificate #{e.message}")
  #   end

  #   result
  # end

  # def self.parse_and_create_from_file(cert_name, file_path, organisation)
  #   content = File.read(file_path)
  #   create_from_raw_content(cert_name, content, organisation)
  # end
  
  def self.from_raw_content(organisation, name, content)
    new_certificate = Certificate.new(organisation:, name:, content:)
  end

  # def self.create_from_raw_content(name, content, organisation)
  #   new_certificate = Certificate.new(organisation:, name:, content:)
  #   begin
  #     x509 = OpenSSL::X509::Certificate.new(content)
  #   rescue OpenSSL::X509::CertificateError => e
  #     new_certificate.errors.add(:content, "Problem reading certificate #{e.message}")
  #   end
    
  #   if x509
  #     new_certificate.subject = x509.subject.to_s
  #     new_certificate.issuer = x509.issuer.to_s
  #     new_certificate.valid_from = x509.not_before
  #     new_certificate.valid_to = x509.not_after
  #     new_certificate.serial_number = x509.serial.to_s(16)
  #   end

  #   new_certificate
  # end

  # attr_accessor :subject

  def extract_raw_content
    begin
      x509 = OpenSSL::X509::Certificate.new(content)
      @subject = x509.subject.to_s
      @issuer = x509.issuer.to_s
      @valid_from = x509.not_before
      @valid_to = x509.not_after
      @serial_number = x509.serial.to_s(16)
    rescue OpenSSL::X509::CertificateError => e
      errors.add(:content, "Problem reading certificate: #{e.message}")
    end
  end

end

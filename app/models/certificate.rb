require "openssl"

class Certificate < ApplicationRecord
  belongs_to :organisation
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :organisation_id }
  validates :subject, :issuer, :valid_from, :valid_to, :serial_number, :content, presence: true

  MAX_LEN = 16

  def import_from_x509_file(file_path)
    content = File.read(file_path)
    import_from_x509_content(content)
  end

  def import_from_x509_content(raw_content)
    x509 = OpenSSL::X509::Certificate.new(raw_content)
    self.content = raw_content
    self.subject = x509.subject.to_s
    self.issuer = x509.issuer.to_s
    self.valid_from = x509.not_before
    self.valid_to = x509.not_after
    self.serial_number = x509.serial.to_s(16)
  rescue OpenSSL::X509::CertificateError => e
    raise "Certificate file issue: #{e.message}"
  end

  def has_expired
    Time.zone.now.after?(valid_to)
  end

  

  def has_oversize_serial_number
    serial_number.length > MAX_LEN
  end

  def get_truncated_serial_number
    truncated_serial = serial_number

    if truncated_serial.length > MAX_LEN
      truncated_serial = truncated_serial[0, MAX_LEN - 3].strip
    end
    
    truncated_serial
  end

end

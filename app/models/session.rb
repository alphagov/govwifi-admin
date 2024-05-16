class Session < ReadReplicaBase
  scope :unsuccessful, lambda {
    where(success: false)
  }

  scope :successful, lambda {
    where(success: true)
  }

  def eap_tls?
    [cert_serial, cert_issuer, cert_subject, cert_name].any?(&:present?)
  end
end

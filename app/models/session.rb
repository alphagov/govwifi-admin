class Session < ReadReplicaBase
  scope :unsuccessful, lambda {
    where(success: false)
  }

  scope :successful, lambda {
    where(success: true)
  }

  def set_authentication_method
    update(authentication_method: [cert_serial, cert_issuer, cert_subject, cert_name].any?(&:present?))
  end
end

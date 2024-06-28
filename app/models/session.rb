class Session < ReadReplicaBase
  scope :unsuccessful, lambda {
    where(success: false)
  }

  scope :successful, lambda {
    where(success: true)
  }

  def eap_tls?
    username.nil?
  end
end

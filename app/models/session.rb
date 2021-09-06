class Session < ReadReplicaBase
  def self.use_index(index)
    from("#{table_name} USE INDEX(#{index})")
  end

  scope :unsuccessful, lambda {
    where(success: false)
  }

  scope :successful, lambda {
    where(success: true)
  }
end

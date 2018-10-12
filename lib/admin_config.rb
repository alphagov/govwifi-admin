class AdminConfig
  def self.mou
    MouTemplate.first_or_create
  end
end

class MouForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :name, :email_address, :job_role, presence: true
  validates :email_address, format: { with: Devise.email_regexp }
  validate :must_be_signed

  attr_accessor :name, :email_address, :job_role, :signed, :token

  def save!(organisation:, user: nil)
    Mou.create!(name:, email_address:, job_role:, organisation:, user:, version: latest_version)
  end

  private
  def latest_version
    BigDecimal(ENV["LATEST_MOU_VERSION"] || BigDecimal("1.0"))
  end
  def must_be_signed
    if signed=="false" || signed==false
      errors.add(:signed, message:"You must accept the terms to sign the MOU")
    end
  end
end

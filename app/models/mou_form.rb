class MouForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :name, :email_address, :job_role, presence: true
  validates :email_address, format: { with: Devise.email_regexp }
  validate :must_be_signed

  attr_accessor :name, :email_address, :job_role, :signed, :token

  def save!(organisation:, user: nil)
    Mou.create!(name:, email_address:, job_role:, organisation:, user:, version: Mou.latest_known_version)
  end

private

  def must_be_signed
    errors.add(:signed, :not_signed) unless signed == "true"
  end
end

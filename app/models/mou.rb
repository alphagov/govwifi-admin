class Mou < ApplicationRecord
  belongs_to :organisation
  belongs_to :user, optional: true

  validates :name, :email_address, :job_role, presence: true
  validates :email_address, format: { with: Devise.email_regexp }
  validates :signed_date, :version, presence: true
  validate :must_be_signed

  def formatted_date
    signed_date.strftime("%e %B %Y")
  end

private

  def must_be_signed
    errors.add(:base, "You must accept the terms to sign the MOU") unless signed
  end
end

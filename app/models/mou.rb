class Mou < ApplicationRecord
  belongs_to :organisation
  belongs_to :user, optional: true

  validates :name, :email_address, :job_role, presence: true
  validates :email_address, format: { with: Devise.email_regexp }
  validate :must_be_signed

  attr_accessor :signed

  def self.latest_version
    ENV["LATEST_MOU_VERSION"].to_i
  end

  def formatted_date
    created_at.strftime("%-d %B %Y")
  end

private

  def must_be_signed
    errors.add(:signed, "You must accept the terms to sign the MOU") unless signed
  end
end

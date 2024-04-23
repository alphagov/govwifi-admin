class Certificate < ApplicationRecord
  belongs_to :organisation

  validates :name, presence: true, uniqueness: { scope: :organisation_id }
  validates :fingerprint, presence: true, uniqueness: { scope: :organisation_id }

  validates :content, :subject, :issuer, :not_before, :not_after, :serial, presence: true
  def root_cert?
    subject == issuer
  end

  def expired?
    Time.zone.now.after?(not_after)
  end

  def nearly_expired?(days)
    warning_start_date = not_after.days_ago(days)
    Time.zone.now.after?(warning_start_date)
  end

  def not_yet_valid?
    not_before.after?(Time.zone.now)
  end
end

class Mou < ApplicationRecord
  belongs_to :organisation

  validates :organisation_name, presence: true
  validates :signed_date, presence: true
  validates :user_name, presence: true
  validates :user_email, presence: true
  validates :version, presence: true
  attribute :signed, :boolean, default: false

  def formatted_date
    signed_date.strftime("%e %B %Y")
  end
end

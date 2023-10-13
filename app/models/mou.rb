class Mou < ApplicationRecord
  belongs_to :organisation
  belongs_to :user

  validates :signed, acceptance: { accept: true }

  validates :signed_date, presence: true
  validates :version, presence: true
  attribute :signed, :boolean, default: false

  def formatted_date
    signed_date.strftime("%e %B %Y")
  end
end

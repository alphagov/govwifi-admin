class Membership < ApplicationRecord
  belongs_to :organisation
  belongs_to :user

  scope :pending, -> { where(confirmed_at: nil) }

  def confirm!
    touch :confirmed_at
  end
end

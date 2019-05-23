class Membership < ApplicationRecord
  belongs_to :organisation
  belongs_to :user
  before_create :set_invitation_token

  scope :pending, -> { where(confirmed_at: nil) }

  def confirm!
    touch :confirmed_at
  end

  def set_invitation_token
    self.invitation_token = Devise.friendly_token[0, 20]
  end
end

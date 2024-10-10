class UserInvitationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :email, presence: true, format: { with: Devise.email_regexp, message: "Invalid Email address" }
  validates :permission_level, presence: true

  attr_accessor :email, :permission_level

  def save!(organisation:, user:, email:, permission_level:)
    return false unless valid?
    user_invitation_form.create!(email:, permission_level:)
    
  end

  # def confirm!
  #   !!confirmed_at: Time.zone.now
  # end
  def set_invitation_token
    self.invitation_token = Devise.friendly_token[0, 20]
  end

private

  def must_be_signed
    errors.add(:email, :permission_level)
  end
end

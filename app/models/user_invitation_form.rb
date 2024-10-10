class UserInvitationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :email, presence: true, format: { with: Devise.email_regexp, message: "Invalid Email address" }
  validates :permission_level, presence: true

  attr_accessor :email, :permission_level

  def save!(current_inviter:, organisation:)
    invited_user = User.invite!({email: email}, current_inviter)

    membership = invited_user.memberships.find_or_create_by!(invited_by_id: current_inviter.id, organisation:)
    membership.update!(
      can_manage_team: permission_level == "administrator",
      can_manage_locations: %w[administrator manage_locations].include?(permission_level),
      )
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

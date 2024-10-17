class UserInvitationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :email, presence: true, format: { with: Devise.email_regexp, message: "Invalid Email address" }
  validates :permission_level, presence: true
  validate :user_is_already_a_member

  attr_accessor :email, :permission_level, :organisation

  def save!(current_inviter:)
    invited_user = User.invite!({ email: }, current_inviter)
    membership = invited_user.memberships.build(invited_by_id: current_inviter.id, organisation:)
    membership.permission_level = permission_level
    membership.save!
    send_invite_membership_email(membership) if user.confirmed?
  end

  # def confirm!
  #   !!confirmed_at: Time.zone.now
  # end
  def set_invitation_token
    self.invitation_token = Devise.friendly_token[0, 20]
  end

private

  def send_invite_membership_email(membership)
    GovWifiMailer.membership_instructions(
      user,
      membership.invitation_token,
      organisation: membership.organisation,
      ).deliver_now
  end

  def user
    @user ||= User.find_by(email:)
  end
  def user_is_already_a_member
    if user&.membership_for(organisation)
      errors.add(:invalid, "This email address is already associated with an administrator account")
    end
  end

  def must_be_signed
    errors.add(:email, :permission_level)
  end
end

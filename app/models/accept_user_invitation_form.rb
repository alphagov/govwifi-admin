class AcceptUserInvitationForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :password,
            presence: true,
            length: { within: 6..80 }
  validate :validate_invitation_token
  validates :name, presence: true
  validate :password_complexity

  attr_accessor :name, :password, :invitation_token

  def save!
    user.update(name:, password:)
    user.confirm
    user.save!
    membership.confirm!
  end

  def user
    membership.user
  end

  def validate_invitation_token
    errors.add(:invalid, "Invalid token") if invalid_invitation_token?
  end

  def invalid_invitation_token?
    membership.nil?
  end

private

  def password_complexity
    errors.add(:weak_password, "Password is not strong enough. Choose a different password.") if Zxcvbn.test(password).score <= Devise.min_password_score
  end

  def membership
    @membership ||= Membership.find_by_invitation_token(invitation_token)
  end
end

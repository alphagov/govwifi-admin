class User < ApplicationRecord
  has_many :memberships, inverse_of: :user, dependent: :destroy
  has_many :organisations, through: :memberships, inverse_of: :users

  accepts_nested_attributes_for :organisations, :memberships

  devise :invitable,
         :confirmable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :timeoutable,
         :validatable,
         :lockable,
         :two_factor_authenticatable,
         :zxcvbnable

  has_one_time_password(encrypted: true)

  validates :name, presence: true, on: :update
  validates :password,
            presence: true,
            length: { within: 6..80 },
            on: :update,
            if: :password_present?,
            confirmation: true

  validate :strong_password, on: :update, if: :password_present?

  def password_present?
    !password.nil?
  end

  def only_if_unconfirmed(&block)
    pending_any_confirmation(&block)
  end

  # Must be defined to allow Devise to create users without passwords
  def password_required?
    false
  end

  def invitation_pending?
    invitation_sent_at && !invitation_accepted?
  end

  def pending_membership_for?(organisation:)
    memberships.pending.where(organisation:).present?
  end

  def can_manage_team?(organisation)
    membership_for(organisation)&.can_manage_team?
  end

  def can_manage_locations?(organisation)
    membership_for(organisation).can_manage_locations?
  end

  def membership_for(organisation)
    memberships.find_by(organisation:)
  end

  def default_membership
    memberships.first
  end

  def can_manage_other_user_for_org?(user, org)
    super_admin? || !!(can_manage_team?(org) && user.membership_for(org))
  end

  def new_super_admin?
    memberships.empty? && is_super_admin?
  end

  def super_admin?
    !membership_for(Organisation.super_admins).nil? || is_super_admin?
  end

  def need_two_factor_authentication?(request)
    return false if ENV.key?("BYPASS_2FA")

    needs_auth = request.env["warden"].session(:user)[TwoFactorAuthentication::NEED_AUTHENTICATION]
    needs_auth.nil? || needs_auth
  end

  def reset_2fa!
    update!(
      second_factor_attempts_count: 0,
      encrypted_otp_secret_key: nil,
      encrypted_otp_secret_key_iv: nil,
      encrypted_otp_secret_key_salt: nil,
      totp_timestamp: nil,
      otp_secret_key: nil,
    )
  end

  def send_new_otp_after_login?
    false
  end
end

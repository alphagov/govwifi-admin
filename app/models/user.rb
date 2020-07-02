class User < ApplicationRecord
  has_many :memberships, inverse_of: :user # rubocop:disable Rails/HasManyOrHasOneDependent
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

  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  # Must be defined to allow Devise to create users without passwords
  def password_required?
    false
  end

  def invitation_pending?
    invitation_sent_at && !invitation_accepted?
  end

  def pending_membership_for?(organisation:)
    memberships.pending.where(organisation: organisation).present?
  end

  def can_manage_team?(organisation)
    membership_for(organisation)&.can_manage_team?
  end

  def can_manage_locations?(organisation)
    membership_for(organisation).can_manage_locations?
  end

  def membership_for(organisation)
    memberships.find_by(organisation: organisation)
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
    (needs_auth != false) || super_admin?
  end

  def reset_2fa!
    update!(
      second_factor_attempts_count: nil,
      encrypted_otp_secret_key: nil,
      encrypted_otp_secret_key_iv: nil,
      encrypted_otp_secret_key_salt: nil,
      totp_timestamp: nil,
      otp_secret_key: nil,
    )
  end

  # No-Op
  # We don't send the otp code to the user, this is a presumption in the two_factor_authentication gem.
  # The method has to be defined to avoid a NotImplementedError.
  # Our workflow is different as we force the user to setup via a bespoke controller.
  def send_two_factor_authentication_code(code); end

  # No-Op
  # We don't store the direct otp code for a user as totp is setup
  # via Users::TwoFactorAuthenticationSetupController so this mechanism is bypassed.
  def create_direct_otp(options = {}); end

  # Indicate to two_factor_authentication gem that we are using TOTP
  def direct_otp
    false
  end
end

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

  enum second_factor_method: { email: "email", app: "app" }

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
    # 2FA becomes mandatory with the new 2FA experience.
    return true if Rails.configuration.enable_enhanced_2fa_experience

    return false if ENV.key?("BYPASS_2FA")

    needs_auth = request.env["warden"].session(:user)[TwoFactorAuthentication::NEED_AUTHENTICATION]
    (needs_auth != false) || super_admin?
  end

  def reset_2fa!
    update!(
      second_factor_attempts_count: 0,
      encrypted_otp_secret_key: nil,
      encrypted_otp_secret_key_iv: nil,
      encrypted_otp_secret_key_salt: nil,
      totp_timestamp: nil,
      otp_secret_key: nil,
      second_factor_method: nil,
    )
  end

  def send_new_otp_after_login?
    second_factor_method == "email"
  end

  def send_two_factor_authentication_code(code)
    UseCases::Administrator::SendOtpEmail.new(
      notifications_gateway: EmailGateway.new,
       ).execute(
         email_address: email,
         name: name,
         url: Rails.application.routes.url_helpers.users_two_factor_authentication_direct_otp_url(code: code),
)
  end

  def has_2fa?
    second_factor_method.present?
  end
end

class User < ApplicationRecord
  has_many :ips
  belongs_to :organisation, optional: true

  devise :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  before_create :reset_confirmation_token, :set_radius_secret_key

  validates_confirmation_of :password
  validate :email_on_whitelist

  def attempt_set_password(params)
    unless params[:password] == params[:password_confirmation]
      errors.add(:password, "must match confirmation") && return
    end
    update(password: params[:password])
  end

  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  # Must be defined to allow Devise to create users without passwords
  def password_required?
    false
  end

private

  def email_on_whitelist
    checker = CheckIfWhitelistedEmail.new
    whitelisted = checker.execute(self.email)[:success]
    errors.add(:email, 'must be from a government domain') unless whitelisted
  end

  # Required as Devise fails to encrypt/digest the user confirmation token when
  # creating the user.  See: https://github.com/plataformatec/devise/issues/2615
  def reset_confirmation_token
    encrypted_token = Devise.token_generator.digest(
      User, :confirmation_token, self.confirmation_token
    )
    self.confirmation_token = encrypted_token
  end

  def set_radius_secret_key
    self.radius_secret_key = RadiusSecretKeyGenerator.new.execute
  end
end

class User < ApplicationRecord
  has_many :ips
  belongs_to :organisation, inverse_of: :users, optional: true
  accepts_nested_attributes_for :organisation

  devise :invitable, :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  before_create :reset_confirmation_token

  validates :name, presence: true, on: :update

  validates :password, confirmation: true, on: :update
  validates :password_confirmation, presence: true, on: :update

  validate :email_on_whitelist

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
end

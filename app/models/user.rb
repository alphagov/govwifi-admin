class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  after_create :reset_confirmation_token

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    unless params[:password] == params[:password_confirmation]
      errors.add(:base, "Passwords must match") and return
    end
    update(password: params[:password])
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  def password_required?
    false
  end

private

  # Required as Devise fails to encrypt/digest the user confirmation token when
  # creating the user.  See: https://github.com/plataformatec/devise/issues/2615
  def reset_confirmation_token
    encrypted_token = Devise.token_generator.digest(
      User, :confirmation_token, self.confirmation_token
    )
    update(confirmation_token: encrypted_token)
  end
end

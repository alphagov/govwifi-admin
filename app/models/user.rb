class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  after_create :reset_confirmation_token

  def attempt_set_password(params)
    unless params[:password] == params[:password_confirmation]
      errors.add(:base, "Passwords must match") && return
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

  # Required as Devise fails to encrypt/digest the user confirmation token when
  # creating the user.  See: https://github.com/plataformatec/devise/issues/2615
  def reset_confirmation_token
    encrypted_token = Devise.token_generator.digest(
      User, :confirmation_token, self.confirmation_token
    )
    update(confirmation_token: encrypted_token)
  end
end

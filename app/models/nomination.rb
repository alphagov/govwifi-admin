class Nomination < ApplicationRecord
  belongs_to :organisation

  validates :nominated_user_name, presence: true
  validates :nominated_user_email, format: { with: Devise.email_regexp }
end

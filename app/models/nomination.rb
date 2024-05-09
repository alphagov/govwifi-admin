class Nomination < ApplicationRecord
  belongs_to :organisation

  validates :name, presence: true
  validates :email, format: { with: Devise.email_regexp }

  delegate :name, to: :organisation, prefix: true
end

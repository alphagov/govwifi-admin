class AuthorisedEmailDomain < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :name, format: { with: /\A[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/, on: :create }
end

class AuthorisedEmailDomain < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :name, with: /\A[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/, on: :create
end

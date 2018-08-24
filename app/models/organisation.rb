class Organisation < ApplicationRecord
  has_many :users, inverse_of: :organisation

  validates :name, presence: true, uniqueness: true
end

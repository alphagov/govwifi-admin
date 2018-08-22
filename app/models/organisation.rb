class Organisation < ApplicationRecord
  has_many :users

  validates :name, presence: true, uniqueness: true
end

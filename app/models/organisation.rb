class Organisation < ApplicationRecord
  has_many :users

  validates_uniqueness_of :name
end

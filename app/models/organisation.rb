class Organisation < ApplicationRecord
  has_many :users, inverse_of: :organisation
  has_many :locations
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: true

  after_create :create_location

private

  def create_location
    self.locations.create
  end
end

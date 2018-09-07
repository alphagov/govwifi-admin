class Organisation < ApplicationRecord
  has_many :users, inverse_of: :organisation
  has_many :locations
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: true

  before_create :set_radius_secret_key
  after_create :create_location

private

  def set_radius_secret_key
    self.radius_secret_key = RadiusSecretKeyGenerator.new.execute
  end

  def create_location
    self.locations.create
  end
end

class Organisation < ApplicationRecord
  has_many :users, inverse_of: :organisation
  has_many :locations
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: true

  def mou_signed?
    true
  end
end

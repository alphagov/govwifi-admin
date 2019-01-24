class Ip < ApplicationRecord
  belongs_to :location

  validates :address, presence: true, uniqueness: true
  validate :address_must_be_valid_ip

  def available?
    created_at < Date.today.beginning_of_day
  end

private

  def address_must_be_valid_ip
    checker = UseCases::Administrator::CheckIfValidIp.new
    valid_ip = checker.execute(self.address)[:success]
    message = "'#{self.address}' is not valid"
    errors.add(:address, message) unless valid_ip
  end
end

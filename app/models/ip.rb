class Ip < ApplicationRecord
  belongs_to :location

  validates :address, presence: true, uniqueness: true
  validate :address_must_be_valid_ip

  def inactive?
    Session
      .where(siteIP: self.address)
      .where("start > #{Date.today - 10.days}")
      .limit(1)
      .empty?
  end

  def available?
    created_at < Date.today.beginning_of_day
  end

private

  def address_must_be_valid_ip
    checker = UseCases::Administrator::CheckIfValidIp.new
    results = checker.execute(self.address)
    errors.add(:address, results[:error_message]) unless results[:success] || address_not_present?
  end

  def address_not_present?
    self.address.nil? || self.address.empty?
  end
end

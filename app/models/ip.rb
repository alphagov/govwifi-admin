class Ip < ApplicationRecord
  belongs_to :location

  validates :address, presence: true, uniqueness: { case_sensitive: true }
  validate :address_must_be_valid_ip

  def inactive?
    Session
      .where(siteIP: address)
      .where("start > ?", Time.zone.today - 10.days)
      .limit(1)
      .empty?
  end

  def available?
    created_at < Time.zone.today.beginning_of_day
  end

  def unused?
    Session
      .where(siteIP: address)
      .limit(1)
      .empty?
  end

private

  def address_must_be_valid_ip
    checker = UseCases::Administrator::CheckIfValidIp.new
    results = checker.execute(address)
    errors.add(:address, results[:error_message]) unless results[:success] || address_not_present?
  end

  def address_not_present?
    address.blank?
  end
end

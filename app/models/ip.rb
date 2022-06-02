class Ip < ApplicationRecord
  belongs_to :location

  delegate :organisation, to: :location

  validates :address, presence: true, uniqueness: { case_sensitive: true }
  validate :address_must_be_valid_ip
  validate :unpersisted_addresses_are_unique

  def unpersisted_addresses_are_unique
    return if persisted? || location&.organisation.nil?

    all_ip_addresses = organisation.locations.flat_map(&:ips).reject(&:persisted?).pluck(:address)
    errors.add(:address, :unpersisted_duplicate, address:) if all_ip_addresses.count(address) > 1
  end

  def inactive?
    @inactive ||= Session
      .where(siteIP: address)
      .where("start > ?", Time.zone.today - 10.days)
      .limit(1)
      .empty?
  end

  def percent_success
    all_count = sessions.count
    return 0 if all_count.zero?

    success_count = sessions.successful.count
    (success_count * 100 / all_count)
  end

  def available?
    created_at < Time.zone.today.beginning_of_day
  end

  def unused?
    @unused ||= Session
      .where(siteIP: address)
      .limit(1)
      .empty?
  end

private

  def sessions(within: 6.hours)
    Session.where(siteIp: address).where("start > ?", Time.zone.now - within)
  end

  def address_must_be_valid_ip
    checker = UseCases::Administrator::CheckIfValidIp.new
    results = checker.execute(address)
    errors.add(:address, results[:error_type], ip_address: address) unless results[:success] || address_not_present?
  end

  def address_not_present?
    address.blank?
  end
end

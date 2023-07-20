class LocationIpsForm
  include ActiveModel::Model
  validate :ips_must_be_valid, :all_empty
  delegate :postcode, :address, :full_address, to: :location

  IP_NUM = 5
  IP_FIELDS = (1..IP_NUM).map { |num| "ip_#{num}".to_sym }

  IP_FIELDS.each do |field|
    attr_accessor field
  end

  attr_accessor :location_id

  def updated_length
    @updated_length ||= ip_data.count(&:present?)
  end

  def update
    return false unless valid?

    ip_data.compact.each { |ip| ip[:model].save }
    UseCases::PerformancePlatform::PublishLocationsIps.new.execute
    UseCases::Radius::PublishRadiusIpAllowlist.new.execute
    true
  end

private

  def location
    @location ||= Location.find(location_id)
  end

  def ips_must_be_valid
    ip_data.compact.each do |ip|
      ip[:model].validate
      ip[:model].errors.each do |error|
        errors.add(ip[:ip_field], error.message)
      end
    end
  end

  def all_empty
    errors.add(:location, "Enter at least one IP address") if ip_data.none?
  end

  def ip_data
    @ip_data ||= IP_FIELDS.map do |ip_field|
      ip_address = send(ip_field)
      next if ip_address.blank?

      {
        ip_field:,
        model:  Ip.new(location:, address: ip_address),
      }
    end
  end
end

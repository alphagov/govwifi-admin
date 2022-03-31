class LogSearchForm
  IP_FILTER_OPTION = "ip".freeze
  USERNAME_FILTER_OPTION = "username".freeze
  LOCATION_FILTER_OPTION = "location".freeze

  include ActiveModel::Model

  attr_accessor :filter_option, :success
  attr_writer :ip, :username, :location_id

  validates :filter_option, presence: true
  validates :username,
            length: { in: 5..6, message: "Search term must be 5 or 6 characters" },
            if: -> { filter_option == USERNAME_FILTER_OPTION }
  validates :ip, with: :validate_ip, if: -> { filter_option == IP_FILTER_OPTION }

  def ip
    filter_option == IP_FILTER_OPTION ? @ip : nil
  end

  def username
    filter_option == USERNAME_FILTER_OPTION ? @username : nil
  end

  def location_id
    filter_option == LOCATION_FILTER_OPTION ? @location_id : nil
  end

  def ordered_locations_of(current_organisation)
    current_organisation.locations.order([:address])
  end

private

  def validate_ip
    ip_check = UseCases::Administrator::CheckIfValidIp.new.execute(ip)
    unless ip_check[:success]
      errors.add(:ip, "Search term must be a valid IP address")
    end
  end
end

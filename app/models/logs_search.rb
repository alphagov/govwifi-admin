class LogsSearch
  include ActiveModel::Model

  attr_accessor :filter, :first_step, :search_term

  validates :search_term, presence: { message: "Search term can't be blank'" }
  validates :search_term,
            length: { in: 5..6, message: "Search term must be 5 or 6 characters" },
            if: -> { filter == "username" }
  validates :search_term, with: :validate_ip, if: -> { filter == "ip" }

  def view_to_render
    {
      email: :contact,
      phone: :contact,
      ip: :ip,
      username: :username,
      location: :location,
    }.fetch(filter.to_sym)
  end

private

  def validate_ip
    ip_check = UseCases::Administrator::CheckIfValidIp.new.execute(search_term)
    unless ip_check[:success]
      errors.add(:search_term, "Search term must be a valid IP address")
    end
  end
end

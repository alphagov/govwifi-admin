class WifiUser < ApplicationRecord
  establish_connection WIFI_USER_DB
  self.table_name = "userdetails"

  def self.search(search_term)
    is_email = search_term =~ Devise.email_regexp
    is_phone = search_term =~ /^[\d]{3,}$/

    search_attr = is_email || is_phone ? :contact : :username

    find_by("#{search_attr} like ?", "%#{search_term}%")
  end
end

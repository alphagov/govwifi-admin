class WifiUser < ApplicationRecord
  establish_connection WIFI_USER_DB
  self.table_name = "userdetails"

  def self.search(search_term)
    search_attr = search_term =~ /^[a-z]{5,6}$/i ? :username : :contact

    find_by(search_attr => search_term)
  end
end

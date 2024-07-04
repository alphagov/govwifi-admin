class WifiUser < ApplicationRecord
  establish_connection WIFI_USER_DB
  self.table_name = "userdetails"

  def self.search(search_term)
    where("contact = ? OR username = ?", search_term, search_term).first ||
      find_by("username like ?", "%#{search_term}%") ||
      find_by("contact like ?", "%#{search_term}%")
  end

  def mobile?
    contact.start_with?("+")
  end
end

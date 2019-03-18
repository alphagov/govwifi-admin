class SupportForm
  include ActiveModel::Model

  attr_accessor :name, :details, :email, :organisation, :phone, :subject, :choice

  validates :details, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp, message: "Email is not a valid email address" }
end

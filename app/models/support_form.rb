class SupportForm
  include ActiveModel::Model

  attr_accessor :name, :details, :email, :organisation, :phone, :subject, :choice

  validates :details, :email, presence: true
end

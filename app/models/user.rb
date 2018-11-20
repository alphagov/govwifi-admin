class User < ApplicationRecord
  belongs_to :organisation, inverse_of: :users, optional: true
  accepts_nested_attributes_for :organisation

  has_one :permission, dependent: :destroy
  accepts_nested_attributes_for :permission

  delegate :can_manage_locations?, :can_manage_team?, to: :permission

  devise :invitable, :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :timeoutable, :validatable, :lockable

  validates :name, presence: true, on: :update

  validates :password, confirmation: true, on: :update
  validates :password_confirmation, presence: true, on: :update

  validate :email_on_whitelist, on: :create

  after_create :create_default_permissions

  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  # Must be defined to allow Devise to create users without passwords
  def password_required?
    false
  end

  def invitation_pending?
    invitation_sent_at && !invitation_accepted?
  end

private

  def create_default_permissions
    Permission.create(
      user: self,
      can_manage_team: true,
      can_manage_locations: true
    )
  end

  def email_on_whitelist
    checker = UseCases::Administrator::CheckIfWhitelistedEmail.new
    whitelisted = checker.execute(self.email)[:success]
    errors.add(:email, 'must be from a government domain') unless whitelisted
  end
end

class User < ApplicationRecord
  belongs_to :organisation, inverse_of: :users, optional: true
  accepts_nested_attributes_for :organisation

  devise :invitable, :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :timeoutable, :validatable, :lockable

  validates :name, presence: true, on: :update

  validates :password, confirmation: true, on: :update
  validates :password_confirmation, presence: true, on: :update

  validate :email_on_whitelist, on: :create

  after_create :add_manage_team_permission!

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

  def can_view_logs?
    true
  end

  def can_view_team?
    true
  end

  def can_view_locations?
    true
  end

  def can_manage_locations?
    true
  end

  def can_manage_team?
    @manage_team
  end

  def add_manage_team_permission!
    @manage_team = true
  end

  def remove_manage_team_permission!
    @manage_team = false
  end

private

  def email_on_whitelist
    checker = UseCases::Administrator::CheckIfWhitelistedEmail.new
    whitelisted = checker.execute(self.email)[:success]
    errors.add(:email, 'must be from a government domain') unless whitelisted
  end
end

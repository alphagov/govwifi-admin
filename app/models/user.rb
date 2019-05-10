class User < ApplicationRecord
  has_and_belongs_to_many :organisations

  has_one :permission, dependent: :destroy
  accepts_nested_attributes_for :permission, :organisations

  delegate :can_manage_locations?, :can_manage_team?, to: :permission

  devise :invitable, :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :timeoutable, :validatable, :lockable

  validates :name, presence: true, on: :update
  validates :password, presence: true,
    length: { within: 6..80 },
    on: :update

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
end

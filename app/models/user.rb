class User < ApplicationRecord
  has_many :memberships, inverse_of: :user
  has_many :organisations, through: :memberships, inverse_of: :users

  accepts_nested_attributes_for :organisations, :memberships

  devise :invitable, :confirmable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :timeoutable, :validatable, :lockable

  validates :name, presence: true, on: :update
  validates :password, presence: true,
    length: { within: 6..80 },
    on: :update

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

  def pending_membership_for?(organisation:)
    memberships.pending.where(organisation: organisation).present?
  end

  def confirm
    memberships.find_or_create_by(
      organisation: organisations.first,
      can_manage_team: true,
      can_manage_locations: true
    )
    super
  end

  def can_manage_team?(organisation)
    membership_for(organisation).can_manage_team?
  end

  def can_manage_locations?(organisation)
    membership_for(organisation).can_manage_locations?
  end

  def membership_for(organisation)
    memberships.where(organisation: organisation).first
  end
end

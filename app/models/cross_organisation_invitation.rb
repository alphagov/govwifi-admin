class CrossOrganisationInvitation < ApplicationRecord
  belongs_to :organisation
  belongs_to :user

  def confirm!
    user.organisations << organisation

    touch :confirmed_at
  end
end

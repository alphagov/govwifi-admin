class Users::InvitationsController < Devise::InvitationsController
  def create
    # add the organisation_id to the user here
    super
  end
end

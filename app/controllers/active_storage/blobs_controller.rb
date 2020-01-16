# NOTE TO READER: this replacement of ActiveStorage's blob controller
# is in place to enforce authentication with devise when accessing a
# blob. At the time of writing, the `/rails/active_storage/blobs/XXX`
# path is not protected which means the Rails app will happily
# generate a valid link to the underlying service+asset and redirect
# anyone who asks there.
#
# Our code adds a filter to check for a logged-in user but also make
# sure they belong to the organisation they are requesting the MoU
# from.
#
# Let's keep in mind that ActiveStorage will naturally evolve and
# probably implement a way to do this without redefining the
# controller itself but in the meantime it means we've started
# diverging. This should be kept in sight and ultimately removed.
#
# PS: a more direct `before_action: authenticate_user!` was causing an
# error, probably because the filter is meant to be used in the
# context of a Rails app rather than its internal engines.

# the following code is copied from the original rails trunk at:
# /active_storage/app/controllers/blobs_controller.rb

# frozen_string_literal: true

# Take a signed permanent reference for a blob and turn it into an expiring service URL for download.
# Note: These URLs are publicly accessible. If you need to enforce access protection beyond the
# security-through-obscurity factor of the signed blob references, you'll need to implement your own
# authenticated redirection controller.
class ActiveStorage::BlobsController < ActiveStorage::BaseController
  include ActiveStorage::SetBlob
  include Rails.application.routes.url_helpers

  before_action :check_user

  def check_user
    if current_user.nil?
      redirect_to new_user_session_path
    else
      # current_organisation is not available here
      org = Organisation.find(
        ActiveStorage::Attachment
          .find_by(blob: @blob)
          .record_id
      )

      unless can? :read_mou, org
        redirect_to overview_index_path, alert: "You are not allowed to see this MoU."
      end
    end
  end

  def show
    expires_in ActiveStorage::Blob.service.url_expires_in
    redirect_to @blob.service_url(disposition: params[:disposition])
  end
end

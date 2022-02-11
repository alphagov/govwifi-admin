module AbleToReadMou
  extend ActiveSupport::Concern

  included do
    before_action :can_read_mou
  end
  def can_read_mou
    attachment = ActiveStorage::Attachment.find_by(blob: @blob)
    return if attachment.name != "signed_mou"

    if cannot? :read_mou, Organisation.find(attachment.record_id)

      path = "/ips"
      redirect_to path, alert: "You are not allowed to see this MoU."
    end
  end
end

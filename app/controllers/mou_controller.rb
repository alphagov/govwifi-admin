class MouController < ApplicationController
  def index
    @mou = AdminConfig.mou.unsigned_document.attachment
    @current_org_signed_mou = current_organisation.signed_mou.attachment
  end

  def create
    redirect_path = if replacing?
                      replaced_mou_index_path(organisation_uuid: current_organisation.uuid)
                    else
                      created_mou_index_path(organisation_uuid: current_organisation.uuid)
                    end

    if params[:signed_mou]
      current_organisation.signed_mou.attach(params[:signed_mou])
      flash[:notice] = "MOU uploaded successfully."
    else
      flash[:alert] = "Choose a file before uploading "
      redirect_path = mou_index_path
    end
    redirect_to redirect_path
  end

private

  def replacing?
    current_organisation.signed_mou.attached?
  end
end

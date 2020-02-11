class MouController < ApplicationController
  def index
    @mou = AdminConfig.mou.unsigned_document.attachment
    @current_org_signed_mou = current_organisation.signed_mou.attachment
  end

  def create
    redirect_path = replacing? ? replaced_mou_index_path : created_mou_index_path
    if params[:signed_mou]
      mime_type = Marcel::MimeType.for(params[:signed_mou])
      if mime_type.to_s == "application/pdf"
        current_organisation.signed_mou.attach(params[:signed_mou])
        flash[:notice] = "MOU uploaded successfully."
      else
        flash[:alert] = "Unsupported file type. Signed MOU should be a PDF."
        redirect_path = mou_index_path
      end
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

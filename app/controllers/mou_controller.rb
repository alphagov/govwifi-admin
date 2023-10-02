class MouController < ApplicationController
  before_action :authorise_mou_creation, only: %i[new create]

  def new
    @mou = Mou.new
  end

  def create
    @mou = Mou.new(mou_params)
    @mou.organisation = current_organisation

    if @mou.save
      flash[:success] = "MOU signed successfully."
    else
      flash[:error] = "Error signing MOU: #{@mou.errors.full_messages.join(', ')}"
    end
    redirect_to settings_path
  end

private

  def mou_params
    params.require(:mou).permit(:signed, :organisation_name, :user_name, :user_email, :signed_date, :organisation, :version)
  end

  def authorise_mou_creation
    unless current_organisation.resign_mou?
      flash[:notice] = "You are not eligible to sign a new MOU at this time."
      redirect_to settings_path
    end
  end
end

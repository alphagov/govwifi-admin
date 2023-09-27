class MouController < ApplicationController

  def new
    @mou = Mou.new
  end

  def create
    @mou = Mou.new(mou_params)
    @mou.organisation = current_organisation

    if @mou.save
      redirect_to settings_path
      flash[:success] = "MOU signed successfully."
    else
      redirect_to settings_path
      flash[:error] = "Error signing MOU: " + @mou.errors.full_messages.join(', ')
    end
  end

private

  def mou_params
    params.require(:mou).permit(:signed, :organisation_name, :user_name, :user_email, :signed_date, :organisation, :version)
  end
end

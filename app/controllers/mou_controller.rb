class MouController < ApplicationController

  def new
    @mou = Mou.new
  end

  def create
    @mou = Mou.new(mou_params)
    @mou.organisation = current_organisation

    if @mou.save
      flash[:success] = "MOU signed successfully."
    else
      raise
      flash[:error] = "Error signing MOU: " + @mou.errors.full_messages.join(', ')

    end

    redirect_to new_mou_path
  end

private

  def mou_params
    params.require(:mou).permit(:signed, :organisation_name, :user_name, :user_email, :signed_date, :organisation, :version)
  end
end

class MouController < ApplicationController
  before_action :authorise_mou_creation, only: %i[new create]

  def new
    @mou = Mou.new
  end

  def create
    if (signed = params.dig(:mou, :signed) == "true")
      @mou = build_mou(signed)

      if @mou.save
        flash[:success] = "MOU signed successfully."
        redirect_to settings_path
      else
        flash[:notice] = "Error signing MOU: #{@mou.errors.full_messages.join(', ')}"
        render :new
      end
    else
      flash[:notice] = "You must accept the terms to sign the MOU."
      render :new
    end
  end

private

  def build_mou(signed)
    Mou.new(
      organisation: current_organisation,
      user: current_user,
      version: current_organisation.latest_mou_version,
      signed_date: Time.zone.today,
      signed:,
    )
  end

  def authorise_mou_creation
    unless current_organisation.resign_mou?
      flash[:notice] = "You are not eligible to sign a new Mou at this time."
      redirect_to settings_path
    end
  end
end

class MouController < ApplicationController
  def index; end

  def update
    current_organisation.signed_mou.attach(params[:signed_mou])
    redirect_to mou_path
  end
  
end 

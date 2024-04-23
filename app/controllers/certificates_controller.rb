class CertificatesController < ApplicationController
  before_action :authorise_manage_certificates
  before_action :authorise_manage_current_certificate, only: %i[show edit destroy]
  before_action :cba_flag_check

  def index
    @certificates = Certificate.where(organisation: current_organisation)
  end

  def show
    @certificate = Certificate.find(params[:id])
  end

  def edit
    @certificate = Certificate.find(params[:id])
  end

  def destroy
    @certificate = Certificate.find(params[:id])
    @certificate.destroy!
    redirect_to(certificates_path, notice: "Successfully removed Certificate: #{@certificate.name}")
  end

  def new
    @certificate_form = CertificateForm.new(organisation: current_organisation)
  end

  def create
    cert_params = params.require(:certificate_form).permit(:file, :name)
    file = cert_params[:file]
    name = cert_params[:name]

    @certificate_form = CertificateForm.new(name:, file:, organisation: current_organisation)
    if @certificate_form.save
      redirect_to(certificates_path, notice: "New Certificate Added: #{@certificate_form.name}")
    else
      render :new, status: :unprocessable_entity
    end
  end

private

  def authorise_manage_current_certificate
    unless can? :manage, Certificate.find(params[:id])
      redirect_to root_path, flash: { error: "You are not allowed to perform this operation" }
    end
  end

  def authorise_manage_certificates
    redirect_to root_path, flash: { error: "You are not allowed to perform this operation" } unless current_user.can_manage_certificates?(current_organisation)
  end

  def cba_flag_check
    redirect_to root_path, flash: { error: "You are not allowed to perform this operation" } unless current_organisation.cba_enabled?
  end
end

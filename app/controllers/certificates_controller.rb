class CertificatesController < ApplicationController
  before_action :authorise_manage_certificates
  before_action :authorise_manage_current_certificate, only: %i[show edit destroy]

  def index
    @pagy, @certificates = pagy(Certificate.where(organisation: current_organisation))
  end

  def show
    @certificate = Certificate.find(params[:id])
  end

  def edit
    @certificate = Certificate.find(params[:id])
  end

  def destroy
    @certificate = Certificate.find(params[:id])
    cert_name = @certificate.name
    @certificate.destroy!
    Services.certificate_repository.delete_certificate(current_organisation.id, cert_name, @certificate.is_root_cert)
    redirect_to(certificates_path, notice: "Successfully removed Certificate: #{@certificate.name}")
  end

  def new
    @certificate = Certificate.new(organisation: current_organisation)
  end

  def create
    uploaded_file = params.dig(:certificate, :cert)
    cert_name = params.dig(:certificate, :name)
    flash.clear

    if !uploaded_file
      flash[:alert] = "No Certificate file selected. Please choose a file to try again."
    elsif Marcel::MimeType.for(uploaded_file).to_s != "application/x-x509-ca-cert"
      flash[:alert] = "Unsupported file type. Should be an x509 certificate file (often .pem)."
    else
      @certificate = Certificate.new(organisation: current_organisation, name: cert_name)
      raw_cert = uploaded_file.read
      @certificate.import_from_x509_content(raw_cert)
      @certificate.save!
      Services.certificate_repository.store_certificate(current_organisation.id, @certificate.name, raw_cert, @certificate.is_root_cert)
      redirect_to(certificates_path, notice: "New Certificate Added: #{@certificate.name}")
    end
  rescue RuntimeError => e
    flash[:alert] = e.message
  rescue ActiveRecord::ActiveRecordError
    # rails validation deals with the user error msgs in this scenario
  ensure
    unless performed?
      @certificate ||= Certificate.new(organisation: current_organisation, name: cert_name)
      render :new
    end
  end

private

  def authorise_manage_current_certificate
    unless can? :manage, Certificate.find(params[:id])
      redirect_to root_path, error: "You are not allowed to perform this operation"
    end
  end

  def authorise_manage_certificates
    redirect_to root_path, error: "You are not allowed to perform this operation" unless current_user.can_manage_certificates?(current_organisation)
  end
end

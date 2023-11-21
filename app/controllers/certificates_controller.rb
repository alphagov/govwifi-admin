class CertificatesController < ApplicationController
  def index
    @pagy, @certificates = pagy(Certificate.where(organisation: current_organisation))
  end

  def new
    @certificate = Certificate.new(organisation: current_organisation)
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

    redirect_to(certificates_path, notice: "Successfully removed Certificate #{@certificate.name}")
  end

  def create
    uploaded_file = params.dig(:certificate, :cert)
    cert_name = params.dig(:certificate, :name)

    if uploaded_file
      flash.clear
      raw_cert = uploaded_file.read
      mime_type = Marcel::MimeType.for(uploaded_file)
      
      if mime_type.to_s == "application/x-x509-ca-cert"
        @certificate = Certificate.from_raw_content(current_organisation, cert_name, raw_cert)
      else
        flash[:alert] = "Unsupported file type. Certificate should be a pem."
      end
    else
       flash[:alert] = "No Certificate file selected. Please choose a file to try again."
    end

    
    if @certificate&.save
      bucketkey = Gateways::S3::RADIUS_CERTS_LOCATION
      s3_cert_key_name = "#{current_organisation.id}_#{cert_name}.pem"
      key_path = File.join(bucketkey[:key], s3_cert_key_name)
      Gateways::S3.new(bucket: bucketkey[:bucket], key:key_path).write(raw_cert)
      redirect_to(certificates_path, notice: "New Certificate Added: #{@certificate.name}")
    else
      if not @certificate
        @certificate = Certificate.new(organisation: current_organisation, name: cert_name)
      end 

      render :new
    end
  end
end

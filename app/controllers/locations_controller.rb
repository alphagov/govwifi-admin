# require "bulk_upload"
# require "bulk_upload/uploaded_csv"

class LocationsController < ApplicationController
  before_action :authorise_manage_locations
  before_action :authorise_manage_current_location, only: %i[add_ips update_ips update]

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(
      address: params.dig(:location, :address),
      postcode: params.dig(:location, :postcode),
      organisation_id: current_organisation.id,
    )

    if @location.save
      redirect_to(ips_path, notice: "Added #{@location.full_address}")
    else
      render :new
    end
  end

  def update
    location = Location.find(params[:id])
    location.update!(radius_secret_key: rotate_radius_secret_key)
    redirect_to(ips_path, notice: "RADIUS secret key has been successfully rotated")
  end

  def add_ips
    @ips_form = LocationIpsForm.new(location_id: location_id_params[:location_id])
  end

  def update_ips
    @ips_form = LocationIpsForm.new(ips_params.merge(location_id_params))
    if @ips_form.update
      redirect_to(
        ips_path,
        notice: "Added #{@ips_form.updated_length} #{'IP address'.pluralize(@ips_form.updated_length)} to #{@ips_form.full_address}",
      )
    else
      render :add_ips
    end
  end

  def upload_locations_csv
    @parent_organisation = current_organisation
    uploaded_csv = BulkUpload::UploadedCsv.new(params[:upload_file], @parent_organisation)
    if uploaded_csv.error_message
      @csv_error = uploaded_csv.error_message
      render("bulk_upload") and return
    end
    BulkUpload::BulkUpload.validate_upload(uploaded_csv.data, @parent_organisation)
    if @parent_organisation.valid?
      @valid_upload_id =
        ActiveStorage::Blob.create_and_upload!(io: params[:upload_file], filename: BulkUpload::BulkUpload.generate_blob_name(@parent_organisation.id)).signed_id
    end
    render("upload_summary")
  end

  def confirm_upload
    blob = ActiveStorage::Blob.find_signed(params[:valid_upload_id])
    blob.open do |file_path|
      uploaded_csv = BulkUpload::UploadedCsv.new(file_path, current_organisation)
      BulkUpload::BulkUpload.save_upload(uploaded_csv.data, current_organisation)
    end
    blob.purge_later
    redirect_to(ips_path, notice: "Successfully uploaded locations")
  end

  def destroy
    location = current_organisation.locations.find_by(id: params.fetch(:id))
    redirect_to ips_path && return unless location && location.ips.empty?

    location.destroy!
    redirect_to ips_path, notice: "Successfully removed location #{location.address}"
  end

private

  def ips_params
    params.require(:location_ips_form).permit(LocationIpsForm::IP_FIELDS)
  end

  def location_id_params
    params.permit(:location_id, :location_ips_form)
  end

  def rotate_radius_secret_key
    use_case = UseCases::Administrator::GenerateRadiusSecretKey.new
    use_case.execute
  end

  def present_ips
    location_params = params
      .require(:location)
      .permit(ips_attributes: [:address])

    location_params[:ips_attributes].reject do |_, a|
      a["address"].blank? || @location.ips.map(&:address).include?(a["address"])
    end
  end

  def authorise_manage_current_location
    unless can? :edit, Location.find(params[:location_id] || params[:id])
      redirect_to root_path, error: "You are not allowed to perform this operation"
    end
  end
end

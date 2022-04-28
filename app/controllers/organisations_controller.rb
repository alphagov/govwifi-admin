class OrganisationsController < ApplicationController
  before_action :set_organisation, only: %i[edit update]
  before_action :validate_user_is_part_of_organisation, only: %i[edit update]
  skip_before_action :redirect_user_with_no_organisation, only: %i[new create]

  attr_reader :hide_sidebar

  def new
    @organisation = Organisation.new
    @hide_sidebar = true
    render :new, locals: { organisation_options: }
  end

  def create
    @organisation = Organisation.new(organisation_params)

    if @organisation.save
      assign_user_to_organisation(@organisation)
      set_as_current_organisation(@organisation)

      redirect_to root_path, notice: "#{@organisation.name} created"
    else
      @hide_sidebar = true
      render :new, locals: { organisation_options: }
    end
  end

  def edit; end

  def update
    if @organisation.update(organisation_params)
      redirect_to settings_path, notice: "Service email updated"
    else
      render :edit
    end
  end

private

  def organisation_options
    Organisation.fetch_organisations_from_register.prepend("").map { |org| OpenStruct.new(name: org) }
  end

  def sidebar
    @hide_sidebar ? :empty : super
  end

  def set_organisation
    @organisation = Organisation.find(params.fetch(:id))
  end

  def validate_user_is_part_of_organisation
    unless @organisation == current_organisation
      raise ActionController::RoutingError, "Not Found"
    end
  end

  def assign_user_to_organisation(organisation)
    current_user.memberships.create(
      organisation:,
      confirmed_at: Time.zone.now,
    )
  end

  def set_as_current_organisation(organisation)
    session[:organisation_id] = organisation.id
  end

  def organisation_params
    params.require(:organisation).permit(:service_email, :name)
  end
end

class OrganisationsController < ApplicationController
  def index
    @all_organisations = Organisation.all
  end
end

require "rails_helper"

RSpec.describe LocationsController, type: :controller do
  let(:user) { create(:user, :with_organisation) }
  let(:location) { create(:location, organisation: user.organisations.first) }
  let(:other_location) { create(:location, organisation: create(:organisation)) }

  describe "GET /add_ips" do
    before do
      sign_in user
    end

    it "renders the add ip view" do
      response = get :add_ips, params: { location_id: location.id }

      expect(response).to render_template "add_ips"
    end

    context "when the user does not belong to the organisation" do
      it "redirects to user locations page" do
        response = get :add_ips, params: { location_id: other_location.id }

        expect(response).to redirect_to(ips_path)
      end
    end
  end
end

require "rails_helper"

require "support/filters/validate_can_manage_team"

RSpec.describe Users::TwoFactorAuthenticationController, type: :controller do
  let(:organisation) { create(:organisation) }

  let(:superadmin) { create(:user, :super_admin) }
  let(:admin) { create(:user, :with_2fa, organisations: [organisation]) }
  let(:stranger) { create(:user, :with_organisation, :with_2fa) }
  let(:teammate) { create(:user, :with_2fa, organisations: [organisation]) }

  describe "edit" do
    it_behaves_like "when using validate_can_manage_team" do
      let(:action) { :edit }
    end

    context "when the filter passes" do
      before do
        sign_in superadmin
      end

      it "renders the correct template" do
        response = get(:edit, params: { id: teammate.id })

        expect(response).to render_template "edit"
      end
    end
  end

  describe "delete" do
    it_behaves_like "when using validate_can_manage_team" do
      let(:action) { :destroy }
    end

    before do
      allow(User).to receive(:find).and_return teammate
      allow(teammate).to receive :reset_2fa!
    end

    context "when operated by a super-admin" do
      before do
        sign_in superadmin
        @response = get :destroy, params: { id: teammate.id }
      end

      it "calls reset_2fa! on the @user" do
        expect(teammate).to have_received :reset_2fa!
      end

      it "redirects to the super admin organisations path" do
        expect(response).to redirect_to super_admin_organisations_path
      end
    end

    context "when operated by a normal admin" do
      before do
        sign_in admin
        @response = get :destroy, params: { id: teammate.id }
      end

      it "calls reset_2fa! on the @user" do
        expect(teammate).to have_received :reset_2fa!
      end

      it "redirects to the current organisation page" do
        expect(response).to redirect_to memberships_path
      end
    end
  end
end

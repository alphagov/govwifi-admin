RSpec.shared_context "when using validate_can_manage_team" do
  let(:organisation) { create(:organisation) }

  let(:superadmin) { create(:user, :super_admin) }
  let(:admin) { create(:user, organisations: [organisation]) }
  let(:stranger) { create(:user, :with_organisation) }
  let(:teammate) { create(:user, organisations: [organisation]) }

  context "when the current_user is not allowed to edit" do
    before do
      sign_in stranger
      @response = get action, params: { id: teammate.id }
    end

    it "redirects to the home page" do
      expect(response).to redirect_to root_path
    end
  end

  context "when the user is allowed to edit" do
    before do
      sign_in admin
      @response = get action, params: { id: teammate.id }
    end

    it "does not redirect to the home page" do
      expect(response).not_to redirect_to root_path
    end
  end

  context "when the user is a super admin" do
    before do
      sign_in superadmin
      @response = get action, params: { id: teammate.id }
    end

    it "does not redirect to the home page" do
      expect(response).not_to redirect_to root_path
    end
  end
end

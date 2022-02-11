describe "GET /home", type: :request do
  let(:user) { create(:user, :with_2fa, :with_organisation) }
  let(:classic_admin) { create(:user, :super_admin) }
  let(:admin) { create(:user, :new_admin) }
  let(:both) { create(:user, :new_admin, :super_admin) }

  before do
    classic_admin
    admin
    both
    https!
  end

  context "when the user is a member of the superadmin org" do
    before do
      sign_in_user classic_admin
    end

    it "redirects to the super admin organisation page" do
      get root_path

      expect(response).to redirect_to("/super_admin/organisations")
    end
  end

  context "when the user is an admin and a member of the superadmin org" do
    before do
      sign_in_user both
    end

    it "redirects to the super admin organisation page" do
      get root_path

      expect(response).to redirect_to("/super_admin/organisations")
    end
  end

  context "when the user is a new admin" do
    before do
      sign_in_user admin
    end

    it "redirects to the help page for no organisations" do
      get root_path

      expect(response).to redirect_to signed_in_new_help_path
    end
  end

  context "when the user is not a super admin" do
    context "with a confirmed organisation" do
      before do
        sign_in_user user
      end

      it "redirects to the locations path" do
        skip "the Organisation factory is broken (cannot be created with valid ips, see FactoryBot.lint)"

        get root_path

        expect(response).to redirect_to ips_path
      end
    end
  end
end

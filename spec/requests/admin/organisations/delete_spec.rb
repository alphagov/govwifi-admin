describe "DELETE /organisations/:id", type: :request do
  let(:organisation) { create(:organisation) }
  let!(:user) { create(:user, organisations: [organisation]) }
  let(:admin_user) { create(:user, :super_admin) }

  before do
    login_as(admin_user, scope: :user)
    https!
  end

  it "deletes the organisation" do
    expect {
      delete admin_organisation_path(organisation)
    }.to change(Organisation, :count).by(-1)
  end

  it "deletes all memberships to that organisation" do
    expect {
      delete admin_organisation_path(organisation)
    }.to change(Membership, :count).by(-1)
  end
end

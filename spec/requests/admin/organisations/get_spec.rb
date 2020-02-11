describe "GET /admin/organisations", type: :request do
  let(:organisation_1) { create(:organisation) }
  let(:organisation_2) { create(:organisation) }
  let(:user) { create(:user, :super_admin) }
  let(:another_user) { create(:user, email: organisation_1.service_email) }

  before do
    another_user; organisation_1; organisation_2
    sign_in_user(user)
    https!
  end

  context "when request format is CSV" do
    it "gets all the organisations" do
      get super_admin_organisations_path(format: "csv")
      csv_response = CSV.parse(response.body, headers: true)
      expect(csv_response.first["Name"]).to eq(organisation_1.name)
    end
  end

  context "when requesting service emails as csv" do
    it "gets all the service emails" do
      get service_emails_super_admin_organisations_path(format: "csv")
      csv_response = CSV.parse(response.body, headers: true)
      expect(csv_response.first["Service email address"]).to eq(organisation_1.service_email)
    end
  end
end

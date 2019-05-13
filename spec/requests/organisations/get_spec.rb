describe "GET /locations", type: :request do
  let!(:organisation_1) { create(:organisation) }
  let!(:organisation_2) { create(:organisation) }
  let(:user) { create(:user, :super_admin) }

  before do
    login_as(user, scope: :user)
    https!
  end

  context 'when request format is CSV' do
    it "gets all the service emails" do
      get admin_organisations_path(format: 'csv')
      expect(response.body).to eq("#{organisation_1.service_email},#{organisation_2.service_email},#{user.organisations.first.service_email}\n")
    end
  end
end

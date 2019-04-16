describe "POST /admin/whitelist", type: :request do
  let(:user) { create(:user, :super_admin) }

  before do
    https!
    login_as(user, scope: :user)
  end

  context "with valid params" do
    let(:gateway) { instance_spy(Gateways::S3, write: nil) }
    let(:valid_params) do
      {
        whitelist: {
          step: 'sixth',
          organisation_name: 'Made Tech',
          email_domain: 'madetech.com'
        }
      }
    end

    before do
      allow(Gateways::S3).to receive(:new).and_return(gateway)
    end

    it "creates the related whitelist objects" do
      expect {
        post admin_whitelist_path, params: valid_params
      }.to change(CustomOrganisationName, :count).by(1)
      .and change(AuthorisedEmailDomain, :count).by(1)
    end

    it 'sends the email domain to S3' do
      post admin_whitelist_path, params: valid_params
      expect(gateway).to have_received(:write)
    end
  end

  context "with invalid params" do
    let(:empty_params) do
      {
        whitelist: {
          step: 'sixth',
          organisation_name: '',
          email_domain: ''
        }
      }
    end

    it "does not create the related whitelist objects" do
      expect {
        post admin_whitelist_path, params: empty_params
      }.to change(CustomOrganisationName, :count).by(0)
      .and change(AuthorisedEmailDomain, :count).by(0)
    end
  end
end

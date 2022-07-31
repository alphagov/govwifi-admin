describe "DELETE /locations/:id", type: :request do
  let(:user) { create(:user, :with_2fa, :with_organisation) }
  let(:organisation) { user.organisations.first }

  before do
    https!
    login_as(user, scope: :user)
    skip_two_factor_authentication
  end

  context "Confirming bulk upload" do
    context "With valid parameters" do
      let(:params) do
        { "csv" =>
            {
              "0" => { "0" => "Address 1", "1" => "AA111AA", "2" => "1.1.1.1" },
              "1" => { "0" => "Address 2", "1" => "BB111BB", "2" => "2.2.2.2" },
            } }
      end
      it "Adds two locations" do
        expect {
          post confirm_upload_path, params:
        }.to change(Location, :count).by(2)
      end
      it "Adds two Ip addresses" do
        expect {
          post confirm_upload_path, params:
        }.to change(Ip, :count).by(2)
      end
      it "redirects with a success message" do
        expect(
          post(confirm_upload_path, params:),
        ).to redirect_to(ips_path)
      end
      it "sets a success flash message" do
        post confirm_upload_path, params: params
        expect(flash[:notice]).to eq("Successfully uploaded locations")
      end
    end
    describe "empty input" do
      let(:params) do
        { csv: {} }
      end
      it "redirects with an error message" do
        expect(
          post(confirm_upload_path, params:),
        ).to redirect_to(ips_path)
      end
      it "sets an error message" do
        post confirm_upload_path, params: params
        expect(flash[:error]).to eq("The uploaded file did not contain any locations.")
      end
    end
    it "does not raise an error with invalid input" do
      expect {
        post confirm_upload_path, params: { "csv" => "invalid" }
      }.to_not raise_error
    end
    context "params that causes a validation error" do
      let(:params) do
        {
          "csv" => {
            "0" => { "0" => "Address 1", "1" => "INVALID" },
          },
        }
      end
      it "redirects with an error message" do
        expect(
          post(confirm_upload_path, params:),
        ).to redirect_to(ips_path)
      end
      it "sets an error message" do
        post confirm_upload_path, params: params
        expect(flash[:error]).to eq("Uploading data failed. Please try again.")
      end
    end
  end
end

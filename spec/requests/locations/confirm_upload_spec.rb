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
            "0" => { "0" => "122",
                     "1" => "London road",
                     "2" => nil,
                     "3" => "London",
                     "4" => "Greater London",
                     "5" => "LE2 0EN",
                     "6" => "192.12.2.3",
                     "7" => "192.15.2.33",
                     "8" => nil,
                     "9" => nil,
                     "10" => nil },
            "1" => { "0" => "101",
                     "1" => "Burton road",
                     "2" => nil,
                     "3" => "Birmingham",
                     "4" => "West Midlands",
                     "5" => "B1 9HH",
                     "6" => "192.14.2.36",
                     "7" => "192.17.2.37",
                     "8" => "192.16.2.38",
                     "9" => nil,
                     "10" => nil },
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
        }.to change(Ip, :count).by(5)
      end
      it "redirects with a success message" do
        expect(
          post(confirm_upload_path, params:),
        ).to redirect_to(ips_path)
      end
      it "sets a success flash message" do
        post confirm_upload_path, params: params
        expect(flash[:notice]).to eq("Upload complete. You have saved 2 new locations and 5 new IP addresses")
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
        { "csv" =>
          {
            "0" => { "0" => "Address line 1",
                     "1" => "Address line 2",
                     "2" => "Address line 3",
                     "3" => "City",
                     "4" => "County",
                     "5" => "Postcode",
                     "6" => "IP address",
                     "7" => "IP address",
                     "8" => "IP address",
                     "9" => "IP address",
                     "10" => "IP address" },
            "1" => { "0" => "Invalid",
                     "1" => nil,
                     "2" => nil,
                     "3" => nil,
                     "4" => nil,
                     "5" => nil,
                     "6" => nil,
                     "7" => nil,
                     "8" => nil,
                     "9" => nil,
                     "10" => nil },
          } }
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

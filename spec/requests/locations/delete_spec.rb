describe "DELETE /locations/:id", type: :request do
  let(:user) { create(:user, :with_2fa, :with_organisation) }
  let!(:location) { create(:location, organisation: user.organisations.first) }

  before do
    https!
    login_as(user, scope: :user)
    skip_two_factor_authentication
  end

  context "when the user owns the location" do
    context "when the location has no IPs" do
      it "deletes the location" do
        expect {
          delete location_path(location)
        }.to change(Location, :count).by(-1)
      end
    end

    context "when the location has an IP" do
      before do
        create(:ip, location:)
      end

      it "does not delete the location" do
        expect {
          delete location_path(location)
        }.to change(Location, :count).by(0)
      end
    end
  end

  context "when the user does not own the location" do
    let!(:other_location) { create(:location) }

    it "does not delete the location" do
      expect {
        delete location_path(other_location)
      }.to change(Location, :count).by(0)
    end
  end
end

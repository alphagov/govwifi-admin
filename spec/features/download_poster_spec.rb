describe "Downloading the poster", type: :feature do
  let(:user) { create(:user, :with_organisation) }

  context "when signed in" do
    before do
      sign_in_user user
      visit settings_poster_path
    end

    it "sends an OK status" do
      expect(page).to have_http_status(200)
    end

    it "sets the filename of the download" do
      expect(page.response_headers["Content-Disposition"]).to include(
        "inline; filename=\"GovWifi-poster.png\"",
      )
    end

    it "sets the content type of the download" do
      expect(page.response_headers["Content-Type"]).to eq(
        "image/png",
      )
    end
  end

  context "when signed out" do
    before do
      visit settings_poster_path
    end

    it_behaves_like "not signed in"
  end
end

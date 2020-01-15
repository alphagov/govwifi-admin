describe "Downloading all the service emails", type: :feature do
  let(:user) { create(:user, :super_admin) }

  before do
    sign_in_user user
    visit super_admin_organisations_path
  end

  it "will have the link to download all service emails" do
    expect(page).to have_content("Download all service emails")
  end

  it "will download a csv file with all the service emails" do
    click_on "Download all service emails"
    expect(page.response_headers["Content-Type"]).to eq("text/csv")
  end
end

describe "Asking the organisation to resign MOU due to version change", type: :feature do
  let(:organisation) { create(:organisation, latest_mou_version: 3.0, mou_version_change_date: Time.zone.today) }
  let(:user) { create(:user, organisations: [organisation]) }
  let!(:mou) do
    create(:mou,
           organisation_id: organisation.id,
           user_id: user.id,
           signed_date: Time.zone.today,
           version: 2.0,
           signed: true,
           created_at: Time.zone.now,
           updated_at: Time.zone.now)
  end

  before do
    sign_in_user user
    visit settings_path
  end

  it "displays a notification after MOU creation" do
    expect(page).to have_content("A new version of the MOU was published")
  end

  it "displays link to sign MOU" do
    expect(page).to have_link("Sign MOU")
  end

  it "displays information on the last signed MOU" do
    expect(page).to have_content("Signed by #{organisation.mou.last.user.name} on #{organisation.mou.last.formatted_date}")
  end

  context "when a user clicks on Sign MOU button" do
    before { click_on "Sign MOU" }

    it "asks the user to sign the MOU" do
      expect(page).to have_content("You must sign a memorandum of understanding (MOU) to use GovWifi.")
    end

    it "increases the MOU count when the user ticks the checkbox and accepts terms" do
      expect {
        check "accept_terms"
        click_button "Accept the MOU"
      }.to change { organisation.mou.count }.by(1)
    end
  end
end

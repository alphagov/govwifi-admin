require 'features/support/sign_up_helpers'

describe "View logs for a username" do
  let!(:user) { create(:user, :confirmed, :with_organisation) }

  before do
    sign_in_user user
    visit logs_search_path
    fill_in "username", with: "AAAAA"
    click_on "Submit"
  end

  it "submits the search form" do
    expect(page).to have_content("Displaying logs for...")
    expect(page).to have_content("AAAAA")
  end
end

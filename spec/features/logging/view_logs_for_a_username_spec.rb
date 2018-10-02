require 'features/support/sign_up_helpers'

describe "View logs for a username" do
  let!(:user) { create(:user, :confirmed, :with_organisation) }

  before do
    sign_in_user user
    visit logging_path
  end

  it "shows the page" do
    expect(page).to have_content("Enter username to view logs")
  end
end

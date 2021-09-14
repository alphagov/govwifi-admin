shared_examples "shows the settings page" do
  it "shows the user the settings page" do
    expect(page).to have_selector("h1", text: "Settings")
  end
end

shared_examples "shows the setup instructions page" do
  it "shows the user the setup instructions page" do
    expect(page).to have_selector("#setup-header", text: "Settings")
  end
end

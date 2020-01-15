shared_examples "errors in form" do
  it "shows there is a problem" do
    expect(page).to have_content "There is a problem"
  end
end

shared_examples 'user not authorised' do
  # Assumes that users created for the purpose of testing have no IPs initially, which routes them differently from root.
  it 'redirects to setting up page' do
    expect(page).to have_selector("#setup-header", text: "Settings")
  end
end

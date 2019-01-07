shared_examples 'user not authorised' do
  it 'redirects to setting up' do
    # this relies on the assumption that users created for the purpose of testing have no IPs, which routes them differently from root.
    expect(page).to have_current_path(setup_instructions_path)
  end
end

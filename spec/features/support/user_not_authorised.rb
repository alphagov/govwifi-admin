shared_examples 'user not authorised' do
  it 'redirects to root page' do
    expect(page).to have_current_path(root_path)
  end
end

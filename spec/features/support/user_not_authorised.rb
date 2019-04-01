shared_examples 'user not authorised' do
  it 'redirects to setting up page' do
    within("h2") do
      expect(page).to have_content("Get GovWifi access in your organisation")
    end
  end
end

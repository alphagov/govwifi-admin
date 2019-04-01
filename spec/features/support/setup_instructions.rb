shared_examples 'display setup instructions' do
  it 'shows the user the setup instructions page' do
    within("h2") do
      expect(page).to have_content("Get GovWifi access in your organisation")
    end
  end
end

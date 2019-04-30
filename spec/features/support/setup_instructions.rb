shared_examples 'shows the setup instructions page' do
  it 'shows the user the setup instructions page' do
    within("#setup-header") do
      expect(page).to have_content("Get GovWifi access in your organisation")
    end
  end
end

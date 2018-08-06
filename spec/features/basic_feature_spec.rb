describe 'homepage', type: :feature do
  it 'says govwifi' do
    visit '/'
    expect(page).to have_content('GovWifi')
  end
end

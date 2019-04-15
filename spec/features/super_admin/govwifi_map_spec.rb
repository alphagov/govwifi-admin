describe 'GovWifi locations', type: :feature do
  before do
    stub_request(:post, 'https://api.postcodes.io/postcodes').
      to_return(status: 200, body: { 'result': [] }.to_json)

    create(:location, postcode: 'SE10HS')
    user = create(:user, :super_admin)
    sign_in_user user
  end

  it 'shows a list' do
    visit admin_govwifi_map_index_path

    expect(page).to have_content('GovWifi Map of Locations')
    assert_requested :post, 'https://api.postcodes.io/postcodes', body: 'postcodes[]=SE10HS'
  end
end

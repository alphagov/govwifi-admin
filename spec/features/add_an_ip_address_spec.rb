describe 'Add an IP to my account' do
  before do
    visit new_ip_path
  end

  it 'displays the page' do
    expect(page).to have_content('Add an IP')
  end
end

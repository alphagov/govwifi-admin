describe 'Add an IP to my account' do
  before do
    visit new_ip_path
  end

  it 'displays the page' do
    expect(page).to have_content('Add an IP')
  end

  it 'creates the IP' do
    fill_in 'address', with: '123213213'
    click_on 'save'
    expect(Ip.count).to eq(1)
  end
end

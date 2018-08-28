shared_examples 'shows activation notice' do
  it 'tells the user IPs are not immediately available' do
    expect(page).to have_content 'New IPs are not immediately available'
  end
end

shared_examples 'shows activation notice' do
  it 'tells the user locations are not immediately available' do
    expect(page).to have_content 'New locations are not immediately available'
  end
end

shared_examples 'shows activation notice' do
  it 'tells me locations are not immediately available' do
    expect(page).to have_content 'New locations are not immediately available'
  end
end

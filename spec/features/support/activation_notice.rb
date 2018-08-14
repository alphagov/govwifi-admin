shared_examples 'shows activation notice' do
  it 'tells the user it takes 24 hours to activate' do
    expect(page).to have_content '24 Hours to Activate'
  end
end

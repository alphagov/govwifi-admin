describe 'user not signed in', focus: true do
  it 'shows the user the not signed in supprt page' do
    visit new_help_path
    expect(page).to have_content 'How can we help you'
  end
end

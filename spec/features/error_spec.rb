describe 'Application errors', type: :feature do
  let(:user) { create(:user) }

  it 'renders a page not found page' do
    sign_in_user user
    visit '/404'

    expect(page).to have_content('Page not found')
  end
end

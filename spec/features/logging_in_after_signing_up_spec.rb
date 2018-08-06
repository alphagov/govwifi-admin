describe 'logging in after signing up' do
  before do
    sign_up_for_account
    create_password_for_account(password: 'f1uffy-bu44ies')

    click_on 'Logout'

    fill_in 'Email', with: 'tom@tom.com'
    fill_in 'Password', with: 'f1uffy-bu44ies'

    click_on 'Log in'
  end

  it 'shows me congratulations' do
    expect(page).to have_content 'Congratulations!'
  end
end

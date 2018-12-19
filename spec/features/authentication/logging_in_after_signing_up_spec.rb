describe 'logging in after signing up', focus: true do
  include_context 'with a mocked notifications client'

  let(:correct_password) { 'f1uffy-bu44ies' }

  before do
    sign_up_for_account(email: 'tom@gov.uk')
    update_user_details(password: correct_password)

    click_on 'Sign out'

    fill_in 'Email', with: 'tom@gov.uk'
    fill_in 'Password', with: password

    click_on 'Continue'
  end

  context 'with correct password' do
    let(:password) { correct_password }

    it 'signs me in' do
      expect(page).to have_content 'Sign out'
    end
  end

  context 'with incorrect password' do
    let(:password) { 'coarse' }

    it_behaves_like 'not signed in'

    it 'displays an error to the user' do
      expect(page).to have_content 'Invalid Email or password'
    end
  end
end

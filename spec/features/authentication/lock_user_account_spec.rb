describe 'Locking a users account' do
  include_context 'with a mocked notifications client'

  let(:correct_password) { 'password' }
  let(:incorrect_password) { 'incorrectpassword' }
  let(:user) { create(:user, password: correct_password) }

  before { visit new_user_session_path }

  context 'when they have tried to login nine times with the wrong password' do
    it 'warns them one more wrong attempt will lock their account' do
      9.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: incorrect_password
        click_on 'Continue'
      end
      expect(page).to have_content 'You have one more attempt before your account is locked.'
    end
  end

  it 'when they have tried to login ten times with the wrong password tells them their account is locked' do
    10.times do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: incorrect_password
      click_on 'Continue'
    end
    expect(page).to have_content 'Your account is locked.'
  end

  context 'when they have tried to login ten times with the wrong password' do
    before do
      10.times do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: incorrect_password
        click_on 'Continue'
      end
    end

    it 'sends one email' do
      expect(notifications.count).to eq 1
    end

    it 'sends the right type of email' do
      expect(notifications.last).to eq 'unlock'
    end

    it 'tells me my account is locked' do
      expect(page).to have_content 'Your account is locked.'
    end
  end
end

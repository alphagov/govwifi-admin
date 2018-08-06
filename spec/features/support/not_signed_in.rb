shared_examples 'not signed in' do
  it 'asks for an email' do
    expect(page).to have_field 'Email'
  end

  it 'asks for a password' do
    expect(page).to have_field 'Password'
  end

  it 'asks me to sign in' do
    expect(page).to have_button 'Log in'
  end
end

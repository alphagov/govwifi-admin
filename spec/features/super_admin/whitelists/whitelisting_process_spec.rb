describe 'Whitelisting an organisation', type: :feature do
  before do
    sign_in_user create(:user, :super_admin)
    visit new_admin_whitelist_path
  end

  it 'displays the start page' do
    expect(page).to have_content('Give an organisation access to GovWifi')
  end

  it 'allows the user to see the list of whitelisted organisations' do
    click_on "Organisations whitelist"
    expect(page).to have_content("Custom Organisations that are already in our register")
  end

  it 'allows the user to see the list of whitelisted email domains' do
    click_on "Users whitelist"
    expect(page).to have_content("Email domains that are already whitelisted")
  end

  context "when stepping through the setup steps" do
    it 'displays the second step' do
      click_on 'Start'
      expect(page).to have_content('Does the organisation need to create a GovWifi admin account?')
    end

    it 'displays the third step' do
      click_on 'Start'
      click_on 'Continue'
      expect(page).to have_content("Is the organisation's name on the register?")
    end

    it 'displays the fourth step' do
      click_on 'Start'
      click_on 'Continue'
      click_on 'Continue'
      expect(page).to have_content('Add the organisation name to the register')
    end

    it 'displays the fifth step' do
      click_on 'Start'
      click_on 'Continue'
      click_on 'Continue'
      click_on 'Continue'
      expect(page).to have_content("Add the organisation's email domain to the whitelist")
    end

    it 'displays the sixth step' do
      click_on 'Start'
      click_on 'Continue'
      click_on 'Continue'
      click_on 'Continue'
      click_on 'Continue'
      expect(page).to have_content("You've whitelisted the organisation to use GovWifi")
    end

    it 'displays the sixth step' do
      click_on 'Start'
      click_on 'Continue'
      click_on 'Continue'
      click_on 'Continue'
      click_on 'Continue'
      click_on 'Done'
      expect(page).to have_content("Give an organisation access to GovWifi")
    end
  end
end

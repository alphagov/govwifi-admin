require 'support/confirmation_use_case'

describe 'adding a custom organisation name' do
  include_examples 'confirmation use case spy'

  let!(:admin_user) { create(:user, super_admin: true) }

  context 'when visiting the custom organisations page' do
    before do
      sign_in_user admin_user
      visit admin_custom_organisations_path
    end

    it 'will show the add custom organisations page' do
      expect(page.body).to have_content('Add Organistions to the Register')
    end

    it 'will redirect you to organiastions page once a custom org is added' do
      fill_in 'custom_organisations[name]', with: 'Custom Org name'
      click_on 'Confirm'
      expect(page).to have_content('Successfully added a custom organisation')
    end

    context 'signout and find custom organisation' do
      before do
        fill_in 'custom_organisations[name]', with: 'Custom Org name'
        click_on 'Confirm'
        sign_out
        sign_up_for_account(email: 'default@gov.uk')
        visit confirmation_email_link
      end
      it 'the custom organisation will appear when creating an account' do
        select 'Custom Org name', from: 'Organisation name'
        fill_in 'Service email', with: 'bob@gov.uk'
        fill_in 'Your name', with: 'bob'
        fill_in 'Password', with: 'bobpassword'
        click_on 'Create my account'
        expect(page).to have_content('Custom Org name')
      end
    end
  end
end

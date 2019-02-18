describe 'Authorised Email Domains' do
  let(:admin_user) { create(:user, super_admin: true) }

  before do
    sign_in_user admin_user
    visit new_admin_authorised_email_domain_path

    fill_in 'Domain', with: some_domain
  end

  context 'Success' do
    let(:some_domain) { 'gov.uk' }

    it 'authorise a new domain' do
      expect { click_on 'Save' }.to change { AuthorisedEmailDomain.count }.by(1)
      expect(page).to have_content("#{some_domain} authorised")
    end
  end

  context 'Submitting a blank domain' do
    let(:some_domain) { '' }

    it 'renders an error' do
      expect { click_on 'Save' }.to_not(change { AuthorisedEmailDomain.count })
      expect(page).to have_content("Name can't be blank")
    end
  end
end

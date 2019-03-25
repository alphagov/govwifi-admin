describe 'Authorising Email Domains', type: :feature do
  before do
    sign_in_user admin_user
    visit new_admin_authorised_email_domain_path
  end

  let(:admin_user) { create(:user, super_admin: true) }

  context 'when whitelisting a domain' do
    before do
      fill_in 'Name', with: some_domain
    end

    context 'when adding a new domain' do
      let(:some_domain) { 'gov.uk' }
      let(:gateway) { instance_spy(Gateways::S3) }

      it 'authorises a new domain' do
        expect { click_on 'Save' }.to change(AuthorisedEmailDomain, :count).by(1)
      end

      it 'displays a success message to the user' do
        click_on 'Save'
        expect(page).to have_content("#{some_domain} authorised")
      end

      it 'publishes the authorised domains to S3' do
        allow(Gateways::S3).to receive(:new).and_return(gateway)
        click_on 'Save'

        expect(gateway).to have_received(:write).with(data: SIGNUP_WHITELIST_PREFIX_MATCHER + '(gov\.uk)$')
      end
    end

    context 'when submitting a blank domain' do
      let(:some_domain) { '' }

      it 'does not create the domain' do
        expect { click_on 'Save' }.not_to(change(AuthorisedEmailDomain, :count))
      end

      it 'displays an error to the user' do
        click_on 'Save'
        expect(page).to have_content("Name can't be blank")
      end
    end

    context 'when deleting a whitelisted domain' do
      let(:some_domain) { 'police.uk' }
      let(:gateway) { instance_spy(Gateways::S3) }

      before do
        click_on 'Save'
        click_on 'Remove'
      end

      it 'removes a domain' do
        expect { click_on "Yes, remove #{some_domain} from the whitelist" }.to change(AuthorisedEmailDomain, :count).by(-1)
      end

      it 'tells the user the domain has been removed' do
        click_on "Yes, remove #{some_domain} from the whitelist"
        expect(page).to have_content("#{some_domain} has been deleted")
      end

      it 'publishes an updated list of authorised domains to S3' do
        allow(Gateways::S3).to receive(:new).and_return(gateway)
        click_on "Yes, remove #{some_domain} from the whitelist"

        expect(gateway).to have_received(:write).with(data: '^$')
      end
    end
  end

  context 'when viewing a list of domains' do
    before do
      %w(a b c).each do |letter|
        create(:authorised_email_domain, name: "#{letter}gov.some.test.uk")
      end
      visit admin_authorised_email_domains_path
    end

    it 'displays the list of all domains in alphabetical order' do
      expect(page.body).to match(/agov.some.test.uk.*bgov.some.test.uk.*cgov.some.test.uk/m)
    end
  end

  context 'without super admin privileges' do
    let(:admin_user) { create(:user, super_admin: false) }

    before do
      sign_in_user admin_user
      visit new_admin_authorised_email_domain_path
    end

    it 'will redirect to root if users type address manually' do
      expect(page).to have_current_path(setup_instructions_path)
    end
  end

  context 'when logged out' do
    before do
      sign_out
      visit new_admin_authorised_email_domain_path
    end

    it_behaves_like 'not signed in'
  end
end

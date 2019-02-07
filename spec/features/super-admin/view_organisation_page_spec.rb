describe 'view details of a signed up organisation' do
  let(:organisation) { create(:organisation) }

  context 'when logged in as a super-admin' do
    let(:location) { create(:location, organisation: organisation) }
    let!(:ip) { create(:ip, location: location) }

    before do
      create(:user, organisation: organisation)

      sign_in_user create(:user, super_admin: true)
      visit admin_organisation_path(organisation)
    end

    it 'shows details page for the organisations' do
      expect(page).to have_content(organisation.name)
    end

    it 'has the creation date of the organisation' do
      expect(page).to have_content(
        organisation.created_at.strftime(
          "#{organisation.created_at.day.ordinalize} of %B, %Y"
        )
      )
    end

    it 'has a Usage section' do
      expect(page).to have_content('Usage')
    end

    it 'shows the number of users' do
      within('#user-count') do
        expect(page).to have_content('1')
      end
    end

    it 'lists the users' do
      organisation.users.each do |user|
        expect(page).to have_content(user.name)
        expect(page).to have_content(user.email)
      end
    end

    it 'shows the number of locations' do
      within('#location-count') do
        expect(page).to have_content('1')
      end
    end

    it 'lists all locations' do
      organisation.locations.each do |location|
        expect(page).to have_content(location.address)
        expect(page).to have_content(location.postcode)
      end
    end

    it 'shows the number of IPs' do
      within('#ip-count') do
        expect(page).to have_content('1')
      end
    end

    context 'with five recent sessions with different usernames' do
      before do
        ('A'..'E').each do |char|
          Session.create(
            siteIP: ip.address,
            success: true,
            username: char * 6,
            start: Time.now.to_s
          )
        end
      end

      it 'shows five unique connections' do
        visit admin_organisation_path(organisation)

        within('#unique-connections') do
          expect(page).to have_content('5')
        end
      end
    end

    it 'has a service email' do
      expect(page).to have_content(organisation.service_email)
    end

    context 'when an MoU does not exist' do
      it 'says no MoU exists' do
        expect(page).to have_content('This organisation has not uploaded an MoU.')
      end

      it 'has an Upload MoU button' do
        within('#mou-upload-form') do
          expect(find_button('Upload MOU')).to be_present
        end
      end
    end

    context 'when an MoU exists' do
      before do
        organisation.signed_mou.attach(
          io: File.open(Rails.root + 'spec/fixtures/mou.pdf'), filename: 'mou.pdf'
        )
        visit admin_organisation_path(organisation)
      end

      it 'has a download button' do
        expect(page).to have_link('download and view the document.')
      end

      it 'has upload date' do
        expect(page).to have_content(
          'A signed MoU was uploaded on ' +
            organisation.signed_mou.attachment.created_at.strftime('%-e %b %Y')
        )
      end

      it 'has a replace MoU button' do
        within('#mou-upload-form') do
          expect(find_button('Replace')).to be_present
        end
      end
    end
  end

  context 'when logged out' do
    before { visit admin_organisation_path(organisation) }

    it_behaves_like 'not signed in'
  end

  context 'when logged in as a normal user' do
    before do
      sign_in_user create(:user)
      visit admin_organisation_path(organisation)
    end

    it_behaves_like 'user not authorised'
  end
end

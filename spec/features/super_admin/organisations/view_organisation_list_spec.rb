describe 'View a list of signed up organisations', type: :feature do
  before do
    login_as user
    visit admin_organisations_path
  end

  context 'when not logged in' do
    let(:user) { nil }

    it_behaves_like 'not signed in'
  end

  context 'when logged in as a normal user' do
    let(:user) { create(:user, :with_organisation) }

    it 'redirects me to the landing guidance' do
      expect(page).to have_content 'If you have trouble setting up GovWifi'
    end
  end

  context 'when logged in as an admin' do
    let(:user) { create(:user, :super_admin) }

    context 'when one organisation exists' do
      let(:org) { create(:organisation, created_at: '1 Feb 2014') }

      before do
        org.signed_mou.attach(
          io: File.open(Rails.root + "spec/fixtures/mou.pdf"), filename: "mou.pdf"
        )
        create_list(:location, 2, organisation: org)
        create_list(:ip, 3, location: Location.first)
        visit admin_organisations_path
      end

      it 'shows their name' do
        within("table") do
          expect(page).to have_content 'Org 1'
        end
      end

      it 'shows when they signed up' do
        within("table") do
          expect(page).to have_content('1 Feb 2014')
        end
      end

      it 'shows they have 10 locations' do
        within("table") do
          expect(page).to have_content('2')
        end
      end

      it 'shows they have 11 IPs' do
        within("table") do
          expect(page).to have_content('3')
        end
      end

      it 'shows they have an MOU' do
        within("table") do
          expect(page).to have_content(org.signed_mou.attachment.created_at.strftime('%e %b %Y'))
        end
      end
    end

    context 'with multiple organisations with multiple locations each' do
      before do
        2.times do
          organisation = create(:organisation)
          create_list(:location, 3, organisation: organisation)
        end

        visit admin_organisations_path
      end

      it 'summarises the totals' do
        expect(page).to have_content(
          "GovWifi is in 6 locations across 3 organisations."
        )
      end

      it 'shows all three organisations' do
        Organisation.all.each do |org|
          expect(page).to have_content(org.name)
        end
      end
    end
  end
end

describe 'viewing the overview page' do
  context 'when logged in' do
    let(:user) { create(:user) }

    context 'with no IPs' do
      before do
        sign_in_user user
        visit root_path
      end

      it 'redirects the user to the setting up page' do
        expect(page.current_path).to eq(setup_instructions_path)
      end

      it 'does not show overview in the navigation' do
        expect(page).to_not have_link("Overview")
      end
    end

    context 'with at least one IP' do
      let(:ip_one) { '141.0.149.130' }
      let(:ip_two) { '141.0.149.131' }
      let(:ip_three) { '141.0.149.132' }
      let(:address_one) { '100 Eastern Street, Southwark' }
      let(:address_two) { '200 Western Street, Whitechapel' }
      let(:postcode_one) { 'SE4 4BK' }
      let(:postcode_two) { 'NE7 3UP' }
      let(:radius_secret_key) { 'E1EAB12AD10B8' }

      before do
        location_one = create(:location,
          organisation: user.organisation,
          address: address_one,
          postcode: postcode_one)

        location_one.update(radius_secret_key: radius_secret_key)

        location_two = create(:location,
          organisation: user.organisation,
          address: address_two,
          postcode: postcode_two)

        create(:ip, address: ip_one, location: location_one)
        create(:ip, address: ip_two, location: location_one)
        create(:ip, address: ip_three, location: location_two)
      end

      context 'within overview section' do
        before do
          sign_in_user user
          visit root_path
        end

        it 'shows an overview of the current installation' do
          within('div#overview') do
            expect(page).to have_link("Team Members")
            expect(page).to have_link("Locations")
            expect(page).to have_link("IPs")
          end
        end

        it 'displays the number of Team members' do
          within('div#team-members') do
            expect(page).to have_content(1)
            expect(page).to have_content("Team Members")
          end
        end

        it 'redirects to the team members page when Team Members is clicked on' do
          click_link 'Team Members'

          expect(page.current_path).to eq(team_members_path)
        end

        it 'displays the number of Locations' do
          within('div#locations') do
            expect(page).to have_content(2)
            expect(page).to have_content("Locations")
          end
        end

        it 'redirects to the IPs page when Locations is clicked on' do
          click_link 'Locations'

          expect(page.current_path).to eq(ips_path)
        end

        it 'displays the number of IPs added' do
          within('div#ips') do
            expect(page).to have_content(3)
            expect(page).to have_content("IPs")
          end
        end

        it 'redirects to the IPs page when IPs is clicked on' do
          within('div#ips') do
            click_link 'IPs'
          end
          expect(page.current_path).to eq(ips_path)
        end
      end
    end
  end
end

require 'support/notifications_service'
require 'support/confirmation_use_case'

describe 'Add an IP to my account' do
  include_examples 'confirmation use case spy'
  include_examples 'notifications service'

  context 'and the new location is invalid' do
    let!(:user) { create(:user) }

    before do
      sign_in_user user
      visit ips_path
      click_on 'Add IP address'
    end

    context 'the location field empty' do
      before do
        fill_in 'address', with: '10.0.0.1'
        fill_in 'ip_location_attributes_address', with: ''
        fill_in 'ip_location_attributes_postcode', with: 'CC DDD'
        click_on 'Add new IP address'
      end

      it_behaves_like 'errors in form'

      it 'tells me what I entered was invalid' do
        expect(page).to have_content(
          "Location address can't be blank"
        )
      end
    end
  end

  context 'to an already existing location' do
    let!(:user) { create(:user) }
    let!(:location_1) { create(:location, address: '10 Street', postcode: 'XX YYY', organisation: user.organisation) }
    let!(:location_2) { create(:location, address: '50 Road', postcode: 'ZZ AAA', organisation: user.organisation) }

    context 'when logged in' do
      before do
        sign_in_user user
        visit ips_path
        click_on 'Add IP address'
      end

      it_behaves_like 'shows activation notice'

      it 'asks me to enter an IP' do
        expect(page).to have_content('Enter IP address (IPv4 only)')
      end

      context 'and that IP is valid' do
        before do
          fill_in 'address', with: '10.0.0.1'
          select '10 Street, XX YYY'
          click_on 'Add new IP address'
        end

        it 'shows me the IP was added' do
          expect(page).to have_content('10.0.0.1 added')
        end

        it 'adds IP to a selected location' do
          expect(Ip.last.location).to eq(location_1)
        end

        context 'when I add a second IP to a different location' do
          before do
            visit new_ip_path
            fill_in 'address', with: '10.0.0.2'
            select '50 Road, ZZ AAA'
            click_on 'Add new IP address'
          end

          it 'shows both new IPs' do
            expect(page).to have_content('10.0.0.1')
            expect(page).to have_content('10.0.0.2')
          end

          it 'adds IP to a selected location' do
            expect(Ip.last.location).to eq(location_2)
          end
        end
      end

      context 'and that IP is invalid' do
        before do
          fill_in 'address', with: '10.wrong.0.1'
          select '10 Street, XX YYY'
          click_on 'Add new IP address'
        end

        it_behaves_like 'errors in form'

        it 'asks me to re-enter my IP' do
          expect(page).to have_content('Enter IP address')
        end

        it 'tells me what I entered was invalid' do
          expect(page).to have_content(
            'Address must be a valid IPv4 address (without subnet)'
          )
        end

        context 'when looking back at the list' do
          before { visit ips_path }

          it 'has not added the invalid IP' do
            expect(page).to_not have_content('10.wrong.0.1')
          end
        end
      end

      context 'and that IP is a duplicate' do
        before do
          create(:ip, address: "1.1.1.1")
          fill_in 'address', with: '1.1.1.1'
          select '10 Street, XX YYY'
          click_on 'Add new IP address'
        end

        it_behaves_like 'errors in form'

        it 'tells me what I entered was invalid' do
          expect(page).to have_content('Address has already been taken')
        end
      end
    end

    context 'to new location' do
      let!(:user) { create(:user) }
      let!(:location_1) { create(:location, address: '10 Street', postcode: 'XX YYY', organisation: user.organisation) }

      context 'when logged in' do
        before do
          sign_in_user user
          visit ips_path
          click_on 'Add IP address'
        end

        context 'and that IP is invalid' do
          before do
            fill_in 'address', with: '10.0.0.1'
            fill_in 'ip_location_attributes_address', with: '30 Square'
            fill_in 'ip_location_attributes_postcode', with: 'CC DDD'
            select '10 Street, XX YYY'
            click_on 'Add new IP address'
          end

          it 'shows me the IP was added' do
            expect(page).to have_content('10.0.0.1 added')
          end

          it 'adds IP to the selected location instead of creating a new one' do
            expect(Ip.last.location.address).to eq('10 Street')
            expect(Ip.last.location.postcode).to eq('XX YYY')
          end
        end

        context 'and that IP is valid' do
          context 'when new location provided BUT old one was selected' do
            before do
              fill_in 'address', with: '10.0.0.1'
              fill_in 'ip_location_attributes_address', with: '30 Square'
              fill_in 'ip_location_attributes_postcode', with: 'CC DDD'
              select '10 Street, XX YYY'
              click_on 'Add new IP address'
            end

            it 'shows me the IP was added' do
              expect(page).to have_content('10.0.0.1 added')
            end

            it 'adds IP to the selected location instead of creating a new one' do
              expect(Ip.last.location.address).to eq('10 Street')
              expect(Ip.last.location.postcode).to eq('XX YYY')
            end
          end

          context 'when new location provided' do
            before do
              fill_in 'address', with: '10.0.0.1'
              fill_in 'ip_location_attributes_address', with: '30 Square'
              fill_in 'ip_location_attributes_postcode', with: 'CC DDD'
              click_on 'Add new IP address'
            end

            it 'shows me the IP was added' do
              expect(page).to have_content('10.0.0.1 added')
            end

            it 'adds IP to a newly created location' do
              expect(Ip.last.location.address).to eq('30 Square')
              expect(Ip.last.location.postcode).to eq('CC DDD')
            end
          end
        end
      end
    end

    context 'when logged out' do
      before { visit new_ip_path }

      it_behaves_like 'not signed in'
    end
  end
end

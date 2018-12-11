require 'features/support/not_signed_in'

describe 'add an IP to an existing location' do
  let!(:location) { create(:location, organisation: user.organisation) }
  let(:user) { create(:user) }

  context 'when logged in' do
    before { sign_in_user user }

    context 'and I select one location' do
      before do
        visit new_ip_path(location: location)
        fill_in 'address', with: ip_address
        click_on 'Add new IP address'
      end

      context 'and enter valid data' do
        let(:ip_address) { '10.0.0.1' }

        it 'adds the IP' do
          expect(page).to have_content("10.0.0.1 added")
        end

        it 'adds to the correct location' do
          expect(location.reload.ips.map(&:address)).to include("10.0.0.1")
        end
      end

      context 'and enter invalid data' do
        let(:ip_address) { '10.wrong.0.1' }

        it 'shows a error message' do
          expect(page).to have_content("'10.wrong.0.1' is not valid")
        end

        it 'does not add an IP to the location' do
          expect(location.reload.ips).to be_empty
        end
      end
    end

    context 'when I select another location' do
      let!(:other_location) do
        create(:location, organisation: user.organisation)
      end

      before do
        visit new_ip_path(location: other_location)
        fill_in 'address', with: "10.0.0.2"
        click_on 'Add new IP address'
      end

      it 'adds the IP' do
        expect(page).to have_content("10.0.0.2 added")
      end

      it 'adds to that location' do
        expect(other_location.reload.ips.map(&:address)).to include("10.0.0.2")
      end
    end
  end

  context 'when not logged in' do
    before { visit new_ip_path(location: location) }

    it_behaves_like 'not signed in'
  end
end

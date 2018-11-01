require 'features/support/not_signed_in'
require 'features/support/sign_up_helpers'

describe 'view list of signed up organisations' do
  context 'when logged out' do
    before { visit organisations_path }

    it_behaves_like 'not signed in'
  end

  context "when logged in" do
    before do
      3.times { create(:organisation) }
    end

    let!(:user) { create(:user, :confirmed, admin: true) }

    context 'when admin navigates to the list page' do
      it 'renders the names of the signed up organisations' do
        sign_in_user user
        visit organisations_path

        Organisation.all.each do |organisation|
          expect(page).to have_content(organisation.name)
        end
      end
    end
  end
end

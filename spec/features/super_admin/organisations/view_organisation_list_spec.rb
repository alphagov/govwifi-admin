describe "View a list of signed up organisations", type: :feature do
  context "when not logged in" do
    before do
      visit super_admin_organisations_path
    end

    it_behaves_like "not signed in"
  end

  context "when logged in as a normal user" do
    let(:user) { create(:user, :with_organisation) }

    before do
      sign_in_user user
      visit super_admin_organisations_path
    end

    it_behaves_like "shows the settings page"
  end

  context "when logged in as an admin" do
    let(:user) { create(:user, :super_admin) }

    before do
      sign_in_user user
      visit super_admin_organisations_path
    end

    context "when one organisation exists" do
      let(:org) { create(:organisation, created_at: "1 Feb 2014") }

      before do
        create_list(:location, 2, organisation: org)
        create_list(:ip, 3, location: Location.first)
        visit super_admin_organisations_path
      end

      it "shows their name" do
        within("table") do
          expect(page).to have_content "Org 1"
        end
      end

      it "shows when they signed up" do
        within("table") do
          expect(page).to have_content("1 Feb 2014")
        end
      end

      it "shows they have 10 locations" do
        within("table") do
          expect(page).to have_content("2")
        end
      end

      it "shows they have 11 IPs" do
        within("table") do
          expect(page).to have_content("3")
        end
      end

      it "shows a link to download as CSV" do
        expect(page).to have_link("Download all organisations in CSV format")
      end

      it "shows a link to download service emails as CSV" do
        expect(page).to have_link("Download all service emails in CSV format")
      end
    end

    context "with multiple organisations with multiple locations each" do
      before do
        2.times do
          organisation = create(:organisation)
          create_list(:location, 3, organisation:)
        end

        visit super_admin_organisations_path
      end

      it "summarises the totals" do
        expect(page).to have_content(
          "GovWifi is in 6 locations across 2 organisations.",
        )
      end

      it "shows all three organisations" do
        Organisation.all.find_each do |org|
          expect(page).to have_content(org.name)
        end
      end
    end
  end
end

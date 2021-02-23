describe "Viewing the overview page", type: :feature do
  let(:user) { create(:user, :with_organisation) }

  context "with no IPs" do
    before do
      sign_in_user user
      visit root_path
    end

    it_behaves_like "shows the setup instructions page"
  end

  context "when viewing the overview section" do
    before do
      sign_in_user user
      visit overview_index_path
    end

    context "without having mou uploaded" do
      it "shows warning that mou must be uploaded" do
        expect(page).to have_selector("#mou-warning")
      end
    end

    context "with having mou already uploaded" do
      before do
        visit mou_index_path
        attach_file("signed_mou", Rails.root + "spec/fixtures/mou.pdf")
        click_on "Upload"
        visit overview_index_path
      end

      it "does not show mou warning" do
        expect(page).not_to have_selector("#mou-warning")
      end
    end
  end

  context "with at least one IP" do
    let(:ip_one) { "141.0.149.130" }
    let(:ip_two) { "141.0.149.131" }
    let(:ip_three) { "141.0.149.132" }
    let(:address_one) { "100 Eastern Street, Southwark" }
    let(:address_two) { "200 Western Street, Whitechapel" }
    let(:postcode_one) { "HA7 3BL" }
    let(:postcode_two) { "HA7 2BL" }
    let(:radius_secret_key) { "E1EAB12AD10B8" }

    before do
      location_one = create(:location,
                            organisation: user.organisations.first,
                            address: address_one,
                            postcode: postcode_one)

      location_one.update!(radius_secret_key: radius_secret_key)

      location_two = create(:location,
                            organisation: user.organisations.first,
                            address: address_two,
                            postcode: postcode_two)

      create(:ip, address: ip_one, location: location_one)
      create(:ip, address: ip_two, location: location_one)
      create(:ip, address: ip_three, location: location_two)
    end

    context "when viewing the overview section" do
      before do
        sign_in_user user
        visit root_path
      end

      it "shows the IPs summary" do
        within("h1#ips-count") do
          expect(page).to have_content(3)
        end
      end

      it "shows the Locations summary" do
        within("h1#locations-count") do
          expect(page).to have_content(2)
        end
      end

      it "displays the Team members summary" do
        within("h1#team-members-count") do
          expect(page).to have_content(1)
        end
      end

      it "redirects to the team members page when Team Members is clicked on" do
        within(".leftnav") do
          click_link "Team members"
        end

        expect(page).to have_current_path(memberships_path)
      end

      it "redirects to the IPs page when Locations is clicked on" do
        within("div#locations") do
          click_link "Locations"
        end

        expect(page).to have_current_path(ips_path)
      end

      it "redirects to the IPs page when IPs is clicked on" do
        within("div#ips") do
          click_link "IP addresses"
        end
        expect(page).to have_current_path(ips_path)
      end
    end
  end
end

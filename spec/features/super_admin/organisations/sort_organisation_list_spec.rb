describe "Sorting the organisations list", type: :feature do
  context "when super admin views the list" do
    let!(:super_admin) { create(:user, :super_admin) }

    before do
      create(:organisation, name: "Gov Org 1", created_at: "10 Dec 2015")
      create(:organisation, name: "Gov Org 2", created_at: "10 Dec 2013")
      create(:organisation, name: "Gov Org 3", created_at: "10 Feb 2014")

      sign_in_user super_admin
      visit super_admin_organisations_path
    end

    context "when sorting by account creation date" do
      it "sorts the list from newest to oldest, by default" do
        expect(page.body).to match(/Gov Org 1.*Gov Org 3.*Gov Org 2/m)
      end

      it "sorts the list from oldest to newest, when Created on is clicked once" do
        click_link "Created on"

        expect(page.body).to match(/Gov Org 2.*Gov Org 3.*Gov Org 1/m)
      end
    end

    context "when sorting by organisation name" do
      it "sorts the list from A -Z, when Name is clicked once" do
        click_link "Name"

        expect(page.body).to match(/Gov Org 1.*Gov Org 2.*Gov Org 3/m)
      end

      it "sorts the list in reverse alphabetical order, when Name is clicked twice" do
        2.times { click_link "Name" }

        expect(page.body).to match(/Gov Org 3.*Gov Org 2.*Gov Org 1/m)
      end
    end

    context "when sorting by signed MoU uploads" do
      before do
        create(:organisation, name: "Gov Org 4")

        Organisation.find_by(name: "Gov Org 1").signed_mou.attach(
          io: File.open(Rails.root.join("spec/fixtures/mou.pdf")), filename: "mou.pdf",
        )

        Organisation.find_by(name: "Gov Org 3").signed_mou.attach(
          io: File.open(Rails.root.join("spec/fixtures/mou.pdf")), filename: "mou.pdf",
        )

        Organisation.find_by(name: "Gov Org 3").signed_mou_attachment.update!(created_at: 3.months.from_now)
      end

      it "sorts the list by oldest to most recent, when MoU signed is clicked once" do
        click_link "MOU Signed"

        expect(page.body).to match(/Gov Org 4.*Gov Org 1.*Gov Org 3/m)
      end

      it "sorts the list by most recent to oldest, when MoU signed is clicked twice" do
        2.times { click_link "MOU Signed" }

        expect(page.body).to match(/Gov Org 3.*Gov Org 1.*Gov Org 4/m)
      end
    end

    context "when sorting by location count" do
      before do
        create(:location, organisation: Organisation.find_by(name: "Gov Org 1"))
        org3 = Organisation.find_by(name: "Gov Org 3")
        create(:location, organisation: org3)
        create(:location, organisation: org3)
      end

      it "sorts the list by number of locations ascending" do
        within(".govuk-table__head") { click_link "Locations" }

        expect(page.text).to match(/Gov Org 2.*Gov Org 1.*Gov Org 3/)
      end

      it "sorts the list by number of locations descending" do
        within(".govuk-table__head") { 2.times { click_link "Locations" } }

        expect(page.text).to match(/Gov Org 3.*Gov Org 1.*Gov Org 2/)
      end
    end

    context "when sorting by ip count" do
      before do
        location1 = create(:location, organisation: Organisation.find_by(name: "Gov Org 1"))
        org3 = Organisation.find_by(name: "Gov Org 3")
        create(:location, organisation: org3)
        location3 = create(:location, organisation: org3)
        create(:ip, location: location1)
        create(:ip, location: location1)
        create(:ip, location: location3)
      end

      it "sorts the list by number of ips ascending" do
        within(".govuk-table__head") { click_link "IPs" }

        expect(page.text).to match(/Gov Org 2.*Gov Org 3.*Gov Org 1/)
      end

      it "sorts the list by number of ips descending" do
        within(".govuk-table__head") { 2.times { click_link "IPs" } }

        expect(page.text).to match(/Gov Org 1.*Gov Org 3.*Gov Org 2/)
      end
    end
  end
end

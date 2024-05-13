describe Ability do
  context "when there is no user logged in" do
    let(:ability) { described_class.new(nil) }

    it "cannot administrate" do
      expect(ability.can?(:administrate, :all)).to be false
    end

    it "cannot manage" do
      expect(ability.can?(:manage, :all)).to be false
    end
  end

  context "when a user is logged in" do
    let(:user) { create(:user, :with_organisation) }
    let(:ability) { described_class.new(user) }

    context "with a normal account" do
      it "can administrate" do
        expect(ability.can?(:administrate, :all)).to be true
      end

      it "cannot manage" do
        expect(ability.can?(:manage, :all)).to be false
      end

      describe "editing locations" do
        let(:location) { create(:location, organisation: user.organisations.first) }
        let(:other_location) { create(:location) }

        context "when the user belongs to the parent organisation" do
          it "can edit the location" do
            expect(ability.can?(:edit, location)).to be true
          end
        end

        context "when the user does not belong to the parent organisation" do
          it "cannot edit the location" do
            expect(ability.can?(:edit, other_location)).to be false
          end
        end
      end
    end

    context "with a superadmin account" do
      let(:user) { create(:user, :super_admin) }

      it "can manage" do
        expect(ability.can?(:manage, :all)).to be true
      end

      it "can administrate" do
        expect(ability.can?(:administrate, :all)).to be true
      end
    end
  end
end

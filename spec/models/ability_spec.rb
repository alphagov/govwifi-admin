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

      describe "reading the MOU" do
        context "when the user is part of the organisation" do
          it "can read the MOU" do
            expect(ability.can?(:read_mou, user.organisations.first)).to be true
          end
        end

        context "when the user is not part of the organisation" do
          let(:other_org) { create(:organisation) }

          it "cannot read the MOU" do
            expect(ability.can?(:read_mou, other_org)).to be false
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

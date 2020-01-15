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
    let(:user) { create(:user) }
    let(:ability) { described_class.new(user) }

    context "with a normal account" do
      it "can administrate" do
        expect(ability.can?(:administrate, :all)).to be true
      end

      it "cannot manage" do
        expect(ability.can?(:manage, :all)).to be false
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

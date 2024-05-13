describe Membership do
  let(:inviter) { create(:user) }
  let(:user) { create(:user) }
  let(:organisation) { create(:organisation) }
  let(:membership) do
    create(:membership,
           user:,
           organisation:,
           invitation_token: "some_token",
           invited_by_id: inviter.id)
  end

  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:user) }

  describe "method permission_level=" do
    it "sets booleans to false when input is view only" do
      membership.permission_level = "view_only"

      expect(membership.can_manage_team).to eq(false)
      expect(membership.can_manage_locations).to eq(false)
    end

    it "sets booleans to true when input is administrator" do
      membership.permission_level = "administrator"

      expect(membership.can_manage_team).to eq(true)
      expect(membership.can_manage_locations).to eq(true)
    end

    it "sets boolean can_manage_team to false and can_manage_team to true when input is manage locations" do
      membership.permission_level = "manage_locations"

      expect(membership.can_manage_team).to eq(false)
      expect(membership.can_manage_locations).to eq(true)
    end
  end

  describe ".confirm!" do
    before do
      membership.confirm!
    end

    it "converts the membership to an organisation" do
      expect(user.organisations.first).to eq(organisation)
    end

    it "will only have one organisation" do
      expect(user.organisations.length).to eq(1)
    end

    it "confirms the membership" do
      expect(membership.confirmed_at).not_to be_nil
    end
  end

  describe ".confirmed?" do
    it "is unconfirmed" do
      membership.update!(confirmed_at: nil)
      expect(membership.confirmed?).to eq(false)
    end

    it "is confirmed" do
      membership.update!(confirmed_at: Time.zone.today)
      expect(membership.confirmed?).to eq(true)
    end
  end
end

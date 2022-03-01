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

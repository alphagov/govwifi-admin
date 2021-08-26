describe Gateways::OrphanUsers do
  subject(:gateway) { described_class.new }

  before do
    create(:user, :with_organisation)
    create(:user, :with_organisation, created_at: 5.days.ago)
    create(:user, :with_organisation, created_at: 8.days.ago)
    create(:user, :with_organisation, created_at: 14.days.ago)
    create(:user)
    create(:user, created_at: 5.days.ago)
  end

  describe "when there are no orphan users older than a week" do
    it "returns an empty set" do
      expect(gateway.fetch.count).to be(0)
    end
  end

  describe "when there is an orphan older than a week" do
    let!(:user1) { create(:user, created_at: 8.days.ago) }
    let!(:user2) { create(:user, created_at: 14.days.ago) }

    it "includes only the orphan users" do
      expect(gateway.fetch).to contain_exactly(user1, user2)
    end
  end
end

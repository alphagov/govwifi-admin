module Gateways
  class OrphanUsers
    def fetch
      User.left_joins(:memberships)
      .where(memberships: { id: nil })
      .where("users.created_at < ?", 1.week.ago)
    end
  end
end

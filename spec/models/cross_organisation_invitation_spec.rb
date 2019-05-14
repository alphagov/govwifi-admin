describe CrossOrganisationInvitation do
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:user) }
end

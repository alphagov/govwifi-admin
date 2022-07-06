describe UseCases::Administrator::FormatOrganisationNames do
  let(:result) { subject.execute(organisation_names) }

  context "when no organisation names" do
    let(:organisation_names) { [] }

    it "creates no allowlist" do
      expect(result.read).to eq("--- []\n")
    end

    it "returns an IO object" do
      expect(result).to be_an_instance_of(StringIO)
    end
  end

  context "when one organisation name is added" do
    let(:organisation_names) { ["Government Digital Services"] }

    it "creates a allowlist with one entry" do
      expect(result.read).to eq("---\n- Government Digital Services\n")
    end
  end

  context "when two organisations name are added" do
    let(:organisation_names) { ["Government Digital Services", "Made Tech"] }

    it "creates a allowlist with two entries" do
      expect(result.read).to eq("---\n- Government Digital Services\n- Made Tech\n")
    end
  end
end

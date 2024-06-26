describe NotifyTemplates do
  describe "#template" do
    it "filters out unused templates" do
      allow(Services.email_gateway).to receive(:all_templates).and_return("unused" => "unused")
      expect { NotifyTemplates.template("unused") }.to raise_error(KeyError)
    end
    it "fetches a template" do
      allow(Services.email_gateway).to receive(:all_templates).and_return(NotifyTemplates::TEMPLATES.first => "template")
      expect(NotifyTemplates.template(NotifyTemplates::TEMPLATES.first)).to eq("template")
    end
    it "accepts symbols" do
      allow(Services.email_gateway).to receive(:all_templates).and_return(NotifyTemplates::TEMPLATES.first => "template")
      expect(NotifyTemplates.template(NotifyTemplates::TEMPLATES.first.to_sym)).to eq("template")
    end
  end
end

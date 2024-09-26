describe NotifyTemplates do
  let(:templates) do
    NotifyTemplates::TEMPLATES.map do |template|
      instance_double(Notifications::Client::Template, name: template, id: "#{template}_id")
    end
  end
  before do
    template_collection = instance_double(Notifications::Client::TemplateCollection, collection: templates)
    notify_gateway = instance_double(Notifications::Client, get_all_templates: template_collection)
    allow(Services).to receive(:notify_gateway).and_return(notify_gateway)
  end
  describe "#template" do
    context "with stubbed gateway" do
      it "filters out unused templates" do
        templates << instance_double(Notifications::Client::Template, name: "unused", id: "unused_id")
        expect { NotifyTemplates.template("unused") }.to raise_error(KeyError)
      end
    end
    it "fetches a template" do
      expect(NotifyTemplates.template("confirmation_email")).to eq("confirmation_email_id")
      expect(NotifyTemplates.template("reset_password_email")).to eq("reset_password_email_id")
    end
    it "accepts symbols" do
      expect(NotifyTemplates.template(:confirmation_email)).to eq("confirmation_email_id")
    end
  end
  describe "#verify_templates" do
    it "verifies all templates" do
      expect {
        NotifyTemplates.verify_templates
      }.to_not raise_error
    end
    it "has a missing template" do
      missing_template = templates.delete_at(0)
      expect {
        NotifyTemplates.verify_templates
      }.to raise_error(StandardError, /Some templates have not been defined in Notify: #{missing_template.name}/)
    end
  end
end

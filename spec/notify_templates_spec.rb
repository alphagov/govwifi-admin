describe NotifyTemplates do
  describe "#template" do
    context "with stubbed gateway" do
      before do
        templates = [instance_double(Notifications::Client::Template, name: "unused", id: "unused")]
        template_collection = instance_double(Notifications::Client::TemplateCollection, collection: templates)
        notify_gateway = instance_double(Notifications::Client, get_all_templates: template_collection)
        allow(Services).to receive(:notify_gateway).and_return(notify_gateway)
      end
      it "filters out unused templates" do
        expect { NotifyTemplates.template("unused") }.to raise_error(KeyError)
      end
    end
    it "fetches a template" do
      expect(NotifyTemplates.template("confirmation_email")).to eq("confirmation_email_template")
      expect(NotifyTemplates.template("reset_password_email")).to eq("reset_password_email_template")
    end
    it "accepts symbols" do
      expect(NotifyTemplates.template(:confirmation_email)).to eq("confirmation_email_template")
    end
  end
end

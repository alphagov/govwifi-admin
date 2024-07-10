describe NotifyTemplates do
  describe "#template" do
    context "with stubbed gateway" do
      before do
        allow(Services).to receive(:notify_gateway).and_return(spy)
        allow(Services.notify_gateway).to receive(:get_all_templates).and_return [double(name: "unused", id: "unused")]
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

class Admin::ContactAllOrgsController < AdminController
  def index
    service_emails = Organisation.pluck(:service_email)

    respond_to do |format|
      format.html
      format.csv { send_data service_emails.to_csv, filename: "service_emails.csv" }
    end
  end
end

module SmsHelpers
  def it_sent_a_notify_user_sms_once
    expect(Services.notify_gateway.count_sms_with_template("notify_user_account_removed_sms_template")).to eq(1)
  end
end

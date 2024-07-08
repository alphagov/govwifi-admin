module SmsHelpers
  def it_sent_a_notify_user_sms_once
    expect(Services.sms_gateway).to have_received(:send_sms)
      .with(include(template_id: GOV_NOTIFY_CONFIG["notify_user_account_removed_sms"]["template_id"])).once
  end
end

module EmailHelpers
  def it_sent_a_confirmation_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["confirmation_email"]["template_id"])).once
  end

  def it_sent_a_confirmation_email_twice
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["confirmation_email"]["template_id"])).twice
  end

  def it_did_not_send_a_confirmation_email
    expect(Services.email_gateway).to_not have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["confirmation_email"]["template_id"]))
  end

  def it_sent_an_invitation_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["invite_email"]["template_id"])).once
  end

  def it_sent_an_invitation_email_twice
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["invite_email"]["template_id"])).twice
  end

  def it_did_not_send_an_invitation_email
    expect(Services.email_gateway).to_not have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["invite_email"]["template_id"]))
  end

  def it_sent_a_cross_organisational_invitation_email
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["cross_organisation_invitation"]["template_id"])).once
  end

  def it_did_not_send_a_cross_organisational_invitation_email
    expect(Services.email_gateway).to_not have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["cross_organisation_invitation"]["template_id"]))
  end

  def it_did_not_send_any_emails
    expect(Services.email_gateway).to_not have_received(:send_email)
  end

  def it_sent_a_nomination_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["nominate_user_to_sign_mou"]["template_id"])).once
  end

  def it_sent_an_admin_mou_prompt_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["admin_mou_prompt_email"]["template_id"])).once
  end

  def it_sent_an_mou_not_signed_by_nominee_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["mou_not_signed_by_nominee"]["template_id"])).once
  end

  def it_sent_a_reminder_to_nominee_to_sign_the_mou_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["reminder_to_nominee_to_sign_the_mou"]["template_id"])).once
  end

  def it_sent_a_thank_you_for_signing_the_mou_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["thank_you_for_signing_the_mou"]["template_id"])).once
  end

  def it_sent_a_notify_user_email_once
    expect(Services.email_gateway).to have_received(:send_email)
      .with(include(template_id: GOV_NOTIFY_CONFIG["notify_user_account_removed"]["template_id"])).once
  end
end

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
end

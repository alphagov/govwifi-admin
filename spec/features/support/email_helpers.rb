module EmailHelpers
  def it_sent_a_confirmation_email_twice
    expect(Services.notify_gateway).to have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:confirmation_email))).twice
  end

  def it_did_not_send_a_confirmation_email
    expect(Services.notify_gateway).to_not have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:confirmation_email)))
  end

  def it_sent_an_invitation_email_once
    expect(Services.notify_gateway).to have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:invite_email))).once
  end

  def it_sent_an_invitation_email_twice
    expect(Services.notify_gateway).to have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:invite_email))).twice
  end

  def it_did_not_send_an_invitation_email
    expect(Services.notify_gateway).to_not have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:invite_email)))
  end

  def it_sent_a_cross_organisational_invitation_email
    expect(Services.notify_gateway).to have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:cross_organisation_invitation))).once
  end

  def it_did_not_send_a_cross_organisational_invitation_email
    expect(Services.notify_gateway).to_not have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:cross_organisation_invitation)))
  end

  def it_did_not_send_any_emails
    expect(Services.notify_gateway).to_not have_received(:send_email)
  end

  def it_sent_a_nomination_email_once
    expect(Services.notify_gateway).to have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:nominate_user_to_sign_mou))).once
  end

  def it_sent_a_thank_you_for_signing_the_mou_email_once
    expect(Services.notify_gateway).to have_received(:send_email)
      .with(include(template_id: NotifyTemplates.template(:thank_you_for_signing_the_mou))).once
  end
end

module CertificateHelpers
  def user_is_not_a_member_of_the_certificates_organisation
    certificate.organisation = create(:organisation, :with_cba_enabled)
    certificate.save!
  end

  def remove_edit_location_permission
    membership = user.membership_for(organisation)
    membership.permission_level = "view_only"
    membership.save!
  end

  def no_cba_enabled_flag
    organisation.disable_cba_feature!
    organisation.save!
  end

  def successfully_renders_template(template)
    expect(response).to have_http_status(:success)
    expect(response).to render_template(template)
  end

  def redirects_with_error_message
    expect(response).to redirect_to root_path
    expect(flash[:error]).to match(/not allowed/)
  end
end

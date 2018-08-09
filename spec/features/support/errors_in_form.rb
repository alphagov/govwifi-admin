shared_examples 'errors in form' do
  it 'shows there is a problem' do
    expect(page).to have_content 'There is a problem'
  end

  it 'adds the error css class' do
    expect(page).to have_css 'div.govuk-form-group--error'
  end
end

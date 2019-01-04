shared_examples 'user not authorised' do
  context 'note that the users set up for testing have no inital IPs' do
    it 'redirects to root page' do
      expect(page).to have_current_path(setup_index_path)
    end
  end
end

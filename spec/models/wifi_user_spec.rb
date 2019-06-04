RSpec.describe WifiUser do
  describe 'search' do
    context 'with username as search term' do
      before { create(:wifi_user, username: 'CfxYtb') }

      it 'finds a wifi user' do
        expect(described_class.search('CFXYTB')).not_to be_nil
      end
    end

    context 'with contact details as search term' do
      before { create(:wifi_user, contact: 'wifi.user@govwifi.org') }

      it 'finds a wifi user' do
        expect(described_class.search('wIfI.uSEr@govWIFI.org')).not_to be_nil
      end
    end
  end
end

describe 'filtering IP addresses by dynamic search', type: :feature do

  before do
    create(:location, organisation: organisation, address: 'Apple Street')
    create(:location, organisation: organisation, address: 'Banana Road')
    create(:location, organisation: organisation, address: 'Citrus Lane')
    sign_in_user user
    visit ips_path
  end

  let!(:organisation) { create(:organisation) }

  let(:user) { create(:user, organisation: organisation) }
  let(:filter_function_string) {
    "(
      function filterLocations(){
        let filterValue = #{filter_value};
        let table = document.getElementById('wrapper')
        let location_name = table.querySelectorAll('table.govuk-table');
        let ips = table.querySelectorAll('tbody#ips-table');

        for(let i = 0;i < location_name.length;i++){
          let text = location_name[i].getElementsByTagName('div')[0];

          if(text.innerHTML.toUpperCase().indexOf(filterValue) > -1){
            location_name[i].style.display = '';
            ips[i].style.display = '';
          } else {
            location_name[i].style.display = 'none';
            ips[i].style.display = 'none';
          }
        }
      }
    )"
  }

  it 'goes to the IPs page' do
    expect(page).to have_current_path('/ips')
  end

  context 'when user fills in the search bar', js: true do
    Capybara.app_host = "http://app:3000"

    let(:filter_value) { 'b' }

    before { page.driver.evaluate_script(filter_function_string) }

    it 'displays Banana Road since it has the letter b, in it' do
      expect(page).to have_content('Banana Road')
    end

    xit 'does not display Apple Street' do
      expect(page).not_to have_content('Apple Street')
    end

    xit 'does not display Citrus Lane' do
      expect(page).not_to have_content('Citrus Lane')
    end
  end
end

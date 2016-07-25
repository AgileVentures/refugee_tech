require 'rails_helper'
RSpec.describe User, type: :model do
    describe 'Geocoder' do
        let(:user_1) { create(:user,
                              user_name: 'Zmago',
                              latitude: 45.960491,
                              longitude: 13.6599124) }
        let(:user_2) { create(:user,
                              user_name: 'Thomas',
                              ip_address: '195.41.5.202',
                              latitude: nil,
                              longitude: nil) }
    
        it 'should set the address to user' do
          expect(user_1.city).to eq 'Kromberk'
          expect(user_1.state).to eq 'Nova Gorica'
          expect(user_1.country).to eq 'Slovenia'
        end
    
        it 'should set the address to user by ip address when are no lat, long' do
          expect(user_2.city).to eq 'Yıldırım'
          expect(user_2.state).to eq 'Bursa'
          expect(user_2.country).to eq 'Turkey'
        end

    end
end
require 'rails_helper'
RSpec.describe User, type: :model do
    describe 'unify_location' do
        let(:user_1) { create(:user,
                              user_name: 'Thomas',
                              mentor: true) }
        let(:user_2) { create(:user,
                              user_name: 'Anders') }
        let(:user_3) { create(:user,
                              user_name: 'Kalle') }
        let(:user_4) { create(:user,
                              user_name: 'Kai') }
        let(:user_5) { create(:user,
                              user_name: 'Bernd') }
    
        before do
          user_1.update(skill_list: 'java-script, testing, ruby')
          user_1.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
          user_2.update(skill_list: 'java-script, java, html')
          user_2.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
          user_3.update(skill_list: 'ionic, html')
          user_3.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
          user_4.update(skill_list: 'java, java-script, html')
          user_4.update(latitude: '53.551085', longitude: '9.993682') #Hamburg, Germany
          user_5.update(skill_list: 'ionic,angular')
          user_5.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
        end
    
        it 'unifies mentors to mentees by skill and area' do
          expect(user_1.unify(location: true)).to include(user_2)
          expect(user_1.unify(location: true)).to_not include(user_3)
        end
    
        it 'does not unify mentors to mentees if too wide apart' do
          expect(user_1.unify(location: true)).not_to include(user_4)
        end
        it 'does not unify mentors to mentees if skills dont match' do
          expect(user_1.unify(location: true)).not_to include(user_3)
        end
        it 'unifies mentorees to mentors and mentees by skill and area' do
          expect(user_2.unify(location: true)).to include(user_3, user_1)
        end
        it 'does not unify mentorees to mentors and mentorees by skill if too wide apart' do
          expect(user_2.unify(location: true)).not_to include(user_4)
        end
        it 'does not unify mentorees to mentors and mentorees by skill if skills dont match' do
          expect(user_2.unify(location: true)).not_to include(user_5)
        end
        it 'does not unify mentors to mentors even if skills match' do
          user_2.update_attributes!(mentor: 'true')
          expect(user_1.unify(location: true)).not_to include(user_2)
        end
      end
  end
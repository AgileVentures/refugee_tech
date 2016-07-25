require 'rails_helper'
RSpec.describe User, type: :model do
  describe 'unify' do
    let(:user_1) { create(:user,
                          user_name: 'Thomas',
                          mentor: true) }
    let(:user_2) { create(:user,
                          user_name: 'Anders') }
    let(:user_3) { create(:user,
                          user_name: 'Kalle') }
    let(:user_4) { create(:user,
                          user_name: 'Sam',
                          mentor: true) }
    
    before do
      user_1.update(skill_list: 'java-script, testing, ruby')
      user_2.update(skill_list: 'java-script, java, html')
      user_3.update(skill_list: 'java, html')
      user_4.update(skill_list: 'testing, ruby')
    end
    
    it 'unifies mentors to mentorees by skill' do
      expect(user_1.unify).to include(user_2)
    end
    
    it 'does not unify mentors to mentorees if no common skill' do
      expect(user_1.unify).not_to include(user_3, user_4)
    end
    
    it 'unifies mentorees to mentors and mentorees by skill' do
      expect(user_2.unify).to include(user_3, user_1)
    end
    
    it 'does not unify mentors to mentors and mentorees if no common skill' do
      expect(user_2.unify).not_to include(user_4)
    end

 end
end
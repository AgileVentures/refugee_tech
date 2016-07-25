require 'rails_helper'
RSpec.describe User, type: :model do
    describe 'Friendships' do
        let(:user_1) { create(:user) }
        let(:user_2) { create(:user) }
        let(:user_3) { create(:user) }
    
        it 'user should be able to add a friend' do
          user_1.invite user_2
          user_1.invite user_3
          user_2.approve user_1
          user_3.approve user_1
          expect(user_1.friends).to include(user_2, user_3)
        end
    end
 end
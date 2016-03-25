require 'rails_helper'

RSpec.describe ApiController, type: :controller do

  let!(:user) { FactoryGirl.create(:user) }
  describe "#current_user" do
    it 'return current user' do
      request.headers['X-User-Email'] = user.email
      request.headers['X-USER-TOKEN'] = user.authentication_token
      expect(controller.current_user).to eq(user)
    end
  end

end

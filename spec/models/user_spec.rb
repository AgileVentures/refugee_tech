require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should be of class User' do
    expect(subject.class).to eq User
  end

  describe 'Database table' do
    it { is_expected.to have_db_column :id }
    it { is_expected.to have_db_column :user_name }
    it { is_expected.to have_db_column :email }
    it { is_expected.to have_db_column :longitude }
    it { is_expected.to have_db_column :latitude }
    it { is_expected.to have_db_column :city }
    it { is_expected.to have_db_column :state }
    it { is_expected.to have_db_column :country }
    it { is_expected.to have_db_column :gender }
    it { is_expected.to respond_to :mentor }
    it { is_expected.to respond_to :private }
    it { is_expected.to respond_to :password }
  end


  it { is_expected.to respond_to :password_confirmation }
  it { is_expected.not_to allow_value("").for(:password) }
  it { is_expected.not_to allow_value("").for(:email) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_confirmation_of(:password) }

  describe 'should not have an invalid email address' do
    emails = ['asdf@ ds.com', '@example.com', 'test me @yahoo.com', 'asdf@example', 'ddd@.d. .d', 'ddd@.d']
    emails.each do |email|
      it { is_expected.not_to allow_value(email).for(:email) }
    end
  end

  describe 'should have a valid email address' do
    emails = ['asdf@ds.com', 'hello@example.uk', 'test1234@yahoo.si', 'asdf@example.eu']
    emails.each do |email|
      it { is_expected.to allow_value(email).for(:email) }
    end
  end
  describe 'Fixtures' do
    
    it 'should have valid Fixture Factory' do
      expect(FactoryGirl.create(:user)).to be_valid
    end

  end

  describe 'scopes' do
    describe 'mentors & mentorees' do
 
      let(:user_1) { create(:user, mentor: true) }
      let(:user_2) { create(:user, mentor: true) }
      let(:user_3) { create(:user, mentor: false) }
      let(:user_4) { create(:user, mentor: false) }
      let(:user_5) { create(:user, mentor: false) }
    
      it '#mentors returns mentors' do
        expect(User.mentors).to include(user_1, user_2)
        expect(User.mentors).not_to include(user_3, user_4, user_5)
      end

      it '#mentorees returns non mentors' do
        expect(User.mentorees).to include(user_3, user_4, user_5)
        expect(User.mentorees).not_to include(user_1, user_2)
      end
    end


    describe 'private profile' do
      
      let(:user_1) { create(:user, private: true) }
      let(:user_2) { create(:user, private: false) }
   
      it 'default scope returns profiles NOT marked private' do
        expect(User.all).to include(user_2)
        expect(User.all).not_to include(user_1)
      end

      it '#private returns profiles with private marked true' do
        expect(User.private_profiles).to include(user_1)
        expect(User.private_profiles).not_to include(user_2)
      end

      it '#all_profiles returns all profiles' do
        expect(User.all_profiles).to include(user_1, user_2)
      end
    end

  end


  describe 'Skills tags' do
    let(:user) { create(:user) }
    
    it 'adds a single skill' do
      user.skill_list.add('java-script')
      expect(user.skill_list).to include /java-script/
    end

    it 'adds multiple skills' do
      user.skill_list.add('java-script', 'ruby', 'dev ops')
      expect(user.skill_list).to eq ['java-script', 'ruby', 'dev ops']
    end
  end

  describe 'unify' do
    let(:user_1) { FactoryGirl.create(:user, user_name: 'Thomas', mentor: true) }
    let(:user_2) { FactoryGirl.create(:user, user_name: 'Anders') }
    let(:user_3) { FactoryGirl.create(:user, user_name: 'Kalle') }
    let(:user_4) { FactoryGirl.create(:user, user_name: 'Sam', mentor: true) }
  
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

  describe 'Geocoder' do
    let(:user_1) { FactoryGirl.create(:user, user_name: 'Zmago', latitude: 45.960491, longitude: 13.6599124 ) }
    let(:user_2) { FactoryGirl.create(:user, user_name: 'Thomas', ip_address: "195.41.5.202", latitude: nil, longitude:nil ) }
    
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
  
  describe 'Gender field' do
    it { is_expected.to allow_values('Male', 'Female', 'male', 'female').for(:gender)}
    it { is_expected.to_not allow_values('Ma', 'asdf', '', 12).for(:gender)}
  end
  
  describe 'Introduction field' do
    let(:long_intro) { 'This introduction and short description of myself has obviously more than the allowed onehundredandfourty characters. Thats sad, because this is way too long for a short description of myself.' }
    let(:short_intro) { 'My short intro' }

    it 'raises error if :introduction is too long' do
      expected_error = ActiveRecord::RecordInvalid
      expected_message = 'Validation failed: Introduction Maximum length is 140 characters'
      expect { FactoryGirl.create(:user, introduction: long_intro) }.to raise_error(expected_error, expected_message)
    end
    
    it 'validates if :introduction is below 140 characters' do
      expect(FactoryGirl.create(:user, introduction: short_intro)).to be_valid
    end
    
     it { is_expected.to validate_length_of(:introduction) }
  end

end

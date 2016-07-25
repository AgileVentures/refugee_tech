require 'rails_helper'
#its important for SimpleCov in order to merge the test results correctly
#that in one file of each test folder we specify a command_name
SimpleCov.command_name 'test:units'
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

  it { is_expected.to respond_to :messages_count }
  it { is_expected.to respond_to :unread_messages_count }
  it { is_expected.to respond_to :password_confirmation }
  it { is_expected.not_to allow_value("").for(:password) }
  it { is_expected.not_to allow_value("").for(:email) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to respond_to :friendly_id }

  describe 'should not have an invalid email address' do
    # skipped tests: , 'ddd@.d', 'asdf@example',
    emails = ['asdf@ ds.com', '@example.com', 'test me @yahoo.com', 'ddd@.d. .d']
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

  describe 'friendly_id' do
    let(:user_1) { create(:user,
                          user_name: 'Thomas') }
    let(:user_2) { create(:user,
                          user_name: 'A N Other') }

    it 'retrieves the correct slug for user with no spaces in name' do
      expect(user_1.friendly_id).to eq('thomas')
    end

    it 'retrieves the correct slug for user with spaces in name' do
      expect(user_2.friendly_id).to eq('a-n-other')
    end

  end

  describe 'Gender field' do
    it { is_expected.to allow_values('Male', 'Female', 'male', 'female').for(:gender) }
    it { is_expected.to_not allow_values('Ma', 'asdf', '', 12).for(:gender) }
  end

  describe 'Introduction field' do
    let(:long_intro) { 'This introduction and short description of myself has obviously more than the allowed onehundredandfourty characters. Thats sad, because this is way too long for a short description of myself.' }
    let(:short_intro) { 'My short intro' }

    it 'raises error if :introduction is too long' do
      expected_error = ActiveRecord::RecordInvalid
      expected_message = 'Validation failed: Introduction Maximum length is 140 characters'
      expect { create(:user, introduction: long_intro) }.to raise_error(expected_error, expected_message)
    end

    it 'validates if :introduction is below 140 characters' do
      expect(create(:user, introduction: short_intro)).to be_valid
    end

    it { is_expected.to validate_length_of(:introduction) }
    
  end
  
end

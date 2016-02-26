require 'rails_helper'

RSpec.describe User, type: :model do

  it 'should be of class User' do
    expect(subject.class).to eq User
  end

  describe 'Database table' do
    it { is_expected.to have_db_column :id }
    it { is_expected.to have_db_column :user_name }
    it { is_expected.to have_db_column :email }
    it { is_expected.to respond_to :mentor }

  end

  it { is_expected.to respond_to :password }
  it { is_expected.to respond_to :password_confirmation }
  it { is_expected.not_to allow_value("").for(:password) }
  it { is_expected.not_to allow_value("").for(:email) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to respond_to :friendly_id }

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

  describe 'friendly_id' do
    let(:user_1) { FactoryGirl.create(:user, user_name: 'Thomas') }
    let(:user_2) { FactoryGirl.create(:user, user_name: 'A N Other') }

    it 'retrieves the correct slug for user with no spaces in name' do
      expect(user_1.friendly_id).to eq("thomas")
    end

    it 'retrieves the correct slug for user with spaces in name' do
      expect(user_2.friendly_id).to eq("a-n-other")
    end


  end

end

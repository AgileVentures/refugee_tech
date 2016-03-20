require 'rails_helper'

describe AdminUser, type: :model do
  
  it 'should be of class AdminUser' do
    expect(subject.class).to eq AdminUser
  end
  
  it 'should be valid' do
    expect(FactoryGirl.create(:admin_user)).to be_valid
  end
  
  context 'should not have an invalid email address' do
    emails = ['asdf@ ds.com', '@example.com', 'test me @yahoo.com', 'asdf@example', 'ddd@.d. .d', 'ddd@.d' ]
    emails.each do |email|
      it { is_expected.not_to allow_value(email).for(:email) }
    end
  end

  context 'should have a valid email address' do
    emails = ['asdf@ds.com', 'hello@example.uk', 'test1234@yahoo.si', 'asdf@example.eu' ]
    emails.each do |email|
      it { is_expected.to allow_value(email).for(:email) }
    end
  end
  
  it { is_expected.not_to allow_value("").for(:password) }

  it { is_expected.to validate_length_of(:password).is_at_least(6) }

  it { is_expected.to validate_uniqueness_of(:email) }
  
  it { is_expected.to validate_presence_of(:email) }
  
  describe '#login_column' do
    it 'should return a email column' do
      expect(AdminUser.login_column).to eq :email    
    end
  end
end
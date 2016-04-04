class AdminUser < ApplicationRecord
  include Godmin::Authentication::User
  
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {  maximum: 105}, 
                                  uniqueness: true,
                                  format: { with: VALID_EMAIL_REGEX }

  def self.login_column
    :email
  end
end

class Language < ActiveRecord::Base

  has_many :user_languages
  has_many :users, through: :user_languages
end

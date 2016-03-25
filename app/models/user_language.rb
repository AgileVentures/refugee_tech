class UserLanguage < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates :written, presence: true
  validates :spoken, presence: true
  validates :level, presence: true
end

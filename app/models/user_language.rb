class UserLanguage < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_inclusion_of :written, in: [true, false]
  validates_inclusion_of :spoken, in: [true, false]
  validates :level, presence: true
end

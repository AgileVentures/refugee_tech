class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :user_name, use: [:slugged, :finders]

  acts_as_taggable_on :skills

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :mentors, -> { where(mentor: true) }
  scope :mentorees, -> { where(mentor: false) }

  def to_s
    user_name
  end

  def unify
    self.mentor ? self.find_related_skills.mentorees : self.find_related_skills
  end
end

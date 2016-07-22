class Skill < ActsAsTaggableOn::Tagging
  inheritance_column = :taggable_type
  belongs_to :user, foreign_key: :taggable_id
end
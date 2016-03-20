class TagService
  include Godmin::Resources::ResourceService

  attrs_for_index :name, :taggings_count
  def resource_class
    ActsAsTaggableOn::Tag
  end
end

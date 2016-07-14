####Hack to make ActsAsTaggableOn work with rails 5
module ActsAsTaggableOn::Utils
  def self.active_record4?
    true
  end
end
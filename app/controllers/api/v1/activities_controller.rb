class Api::V1::ActivitiesController < ApiController

  include Api::V1::ActivitiesDoc

  def index
    @feed  = Api::V1::ActivityFeed.get_fb_feed
  end

end
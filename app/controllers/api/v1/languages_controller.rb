class Api::V1::LanguagesController < ApiController

  def index
    @languages = Language.all 
  end
end

class Api::V1::LanguagesController < ApiController

  include Api::V1::LanguagesDoc

  def index
    @languages = Language.all 
  end

  def create
    @user_lang = current_user.user_languages.build(language_params)
    if @user_lang.save
      render json: {message: 'Successfully saved language'}
    else
      render json: {errors: @user_lang.errors}, status: 401
    end
  end

  def update
    @user_lang = UserLanguage.find(params[:id]) 
    if @user_lang.update_attributes(language_params)
      render json: {message: 'Successfully updated language'}
    else
      render json: {errors: @user_lang.errors}, status: 401
    end
  end

  def destroy
    @user_lang = UserLanguage.find(params[:id]) 
    if @user_lang.destroy
      render json: {message: 'Successfully deleted language'}
    else
      render json: {error: 'an delete error occuried'}, status: 401
    end
  end

  def my_languages
    @langs = current_user.user_languages.includes(:language)
  end



  def language_params
    params.require(:language).permit(:language_id, :spoken, :written, :level)
  end
end

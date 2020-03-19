class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    authorization('GitHub')
  end

  def vkontakte
    authorization('vkontakte')
  end

  def authorization(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted? && !@user.email.include?('uid_')
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user&.persisted? && @user.email.include?('uid_')
      render 'confirmations/email', locals: { resource: @user }
    else
      redirect_to root_path
    end
  end
end

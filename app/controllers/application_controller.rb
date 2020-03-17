class ApplicationController < ActionController::Base
  # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :gon_user

  # def configure_permitted_parameters
  #   update_attrs = [:email]
  #   devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  # end

  private

  def gon_user
    gon.user_id = current_user&.id
  end
end

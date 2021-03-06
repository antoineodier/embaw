class ApplicationController < ActionController::Base
  protect_from_forgery except: :submit_correction
  # with: :exception
  before_filter :authenticate_user!, unless: :pages_controller?

  # include Pundit
  # after_action :verify_authorized, except: :index, unless: :devise_or_pages_or_active_admin_controller?
  # after_action :verify_policy_scoped, only: :index, unless: :devise_or_pages_or_active_admin_controller?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def after_sign_in_path_for(resource)
    transcription_path(1)
  end

  def user_not_authorized
    flash[:error] = I18n.t('controllers.application.user_not_authorized', default: "You can't access this page.")
    redirect_to(root_path)
  end

  def devise_or_pages_or_active_admin_controller?
    devise_controller? || pages_controller? || params[:controller] =~/^admin/
  end

  def pages_controller?
    controller_name == "pages"  # Brought by the `high_voltage` gem
  end
end

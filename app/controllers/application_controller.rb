class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_role_path

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def current_role_path
    return admin_dashboard_path if current_user&.admin?
    return recruiter_dashboard_path if current_user&.recruiter?

    candidate_dashboard_path if current_user&.candidate?
  end

  def authorize_admin!
    redirect_to root_path, alert: "Admins only." unless current_user&.admin?
  end

  def authorize_recruiter!
    redirect_to root_path, alert: "Recruiters only." unless current_user&.recruiter? || current_user&.admin?
  end

  def authorize_candidate!
    redirect_to root_path, alert: "Candidates only." unless current_user&.candidate?
  end
end

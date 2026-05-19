class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role])
  end

  def after_sign_up_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    elsif resource.recruiter?
      recruiter_dashboard_path
    else
      candidate_dashboard_path
    end
  end
end

class DashboardController < ApplicationController
  def show
    redirect_to current_role_path || root_path
  end
end

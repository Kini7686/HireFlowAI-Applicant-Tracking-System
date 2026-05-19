module Recruiter
  class DashboardController < ApplicationController
    before_action :authorize_recruiter!

    def show
      @jobs = current_user.jobs.includes(:applications)
      @applications_count = Application.for_recruiter(current_user).count
      @pending_applications = Application.for_recruiter(current_user).applied.count
    end
  end
end

module Candidate
  class DashboardController < ApplicationController
    before_action :authorize_candidate!

    def show
      @applications = current_user.applications.includes(:job).order(created_at: :desc)
      @profile = current_user.resume_profile
    end
  end
end

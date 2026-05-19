module Recruiter
  class PipelineController < ApplicationController
    before_action :authorize_recruiter!

    def index
      @applications = Application.for_recruiter(current_user)
                                 .includes(:user, :job)
                                 .order(created_at: :desc)
      @grouped = @applications.group_by(&:status)
    end
  end
end

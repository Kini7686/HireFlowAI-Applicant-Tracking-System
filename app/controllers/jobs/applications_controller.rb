module Jobs
  class ApplicationsController < ApplicationController
    before_action :set_job

    def index
      authorize_recruiter!
      @applications = @job.applications.includes(:user).order(created_at: :desc)
    end

    def show
      authorize_recruiter!
      @application = @job.applications.find(params[:id])
    end

    def create
      authorize_candidate!
      @application = current_user.applications.build(job: @job, status: :applied)
      authorize @application

      if @application.save
        NotificationJob.perform_later(
          @job.recruiter_id,
          "New application",
          "#{current_user.name} applied to #{@job.title}.",
          "application_created"
        )
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to application_path(@application), notice: "Application submitted." }
        end
      else
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "job_apply_form",
              partial: "jobs/apply_form",
              locals: { job: @job, application: @application }
            )
          end
          format.html { redirect_to job_path(@job), alert: @application.errors.full_messages.to_sentence }
        end
      end
    end

    private

    def set_job
      @job = if action_name == "create"
               Job.published.find(params[:job_id])
             else
               current_user.jobs.find(params[:job_id])
             end
    end
  end
end

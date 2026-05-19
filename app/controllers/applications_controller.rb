class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[show update update_status recalculate_ats ats_status]

  def index
    @applications = if current_user.admin?
                      Application.includes(:user, :job).order(created_at: :desc)
                    elsif current_user.recruiter?
                      Application.for_recruiter(current_user).includes(:user, :job)
                    else
                      current_user.applications.includes(:job)
                    end
  end

  def show
    authorize @application
  end

  def update
    authorize @application
    old_status = @application.status

    if @application.update(application_params)
      if @application.saved_change_to_status? && old_status != @application.status
        NotificationJob.perform_later(
          @application.user_id,
          "Application status updated",
          "Your application for #{@application.job.title} is now #{@application.status.humanize}.",
          "status_updated"
        )
      end
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @application, notice: "Application updated." }
      end
    else
      render :show, status: :unprocessable_entity
    end
  end

  def update_status
    authorize @application, :update_status?
    @application.update!(status: params[:status])
    NotificationJob.perform_later(
      @application.user_id,
      "Application status updated",
      "Your application for #{@application.job.title} is now #{@application.status.humanize}.",
      "status_updated"
    )
    head :ok
  end

  def ats_status
    authorize @application, :show?
    @application.reload

    row_html = nil
    if request.format.json? && params[:include_row] == "true"
      row_html = render_to_string(
        partial: "applications/application_row",
        locals: { application: @application, show_recalculate: true },
        layout: false
      )
    end

    render json: {
      ats_score: @application.ats_score,
      matched_skills: @application.matched_skills,
      missing_skills: @application.missing_skills,
      row_html: row_html
    }
  end

  def recalculate_ats
    authorize @application, :recalculate_ats?

    unless @application.user.resume_profile&.ready?
      respond_to do |format|
        format.html { redirect_back fallback_location: candidate_dashboard_path, alert: "Upload and parse your resume before recalculating ATS score." }
        format.turbo_stream { redirect_back fallback_location: candidate_dashboard_path, alert: "Upload and parse your resume before recalculating ATS score." }
      end
      return
    end

    @application.update!(
      ats_score: nil,
      matched_skills: nil,
      missing_skills: nil,
      ai_feedback: nil
    )
    AtsScoringJob.perform_later(@application.id)

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_back fallback_location: @application, notice: "ATS score recalculation started. Refresh in a few seconds."
      end
    end
  end

  private

  def set_application
    @application = Application.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:status, :recruiter_notes)
  end
end

class ResumesController < ApplicationController
  before_action :authorize_candidate!

  def show
    @profile = current_user.resume_profile || current_user.create_resume_profile!
  end

  def create
    attach_resume
    enqueue_parsing
    redirect_to resume_path, notice: "Resume uploaded. Processing started."
  end

  def update
    current_user.resume.purge if current_user.resume.attached?
    attach_resume
    enqueue_parsing
    redirect_to resume_path, notice: "Resume replaced. Processing started."
  end

  private

  def attach_resume
    current_user.resume.attach(params[:resume])
    profile = current_user.resume_profile || current_user.create_resume_profile!
    profile.update!(processing_status: :pending, error_message: nil)
  end

  def enqueue_parsing
    ResumeParsingJob.perform_later(current_user.id)
  end
end

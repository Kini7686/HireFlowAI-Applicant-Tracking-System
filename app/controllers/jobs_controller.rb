class JobsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_job, only: %i[show edit update destroy]
  before_action :authorize_recruiter!, only: %i[new create edit update destroy]

  def index
    @jobs = if current_user&.recruiter?
              current_user.jobs.order(created_at: :desc)
            else
              Job.published.includes(:recruiter).order(created_at: :desc)
            end
  end

  def show
    authorize @job if current_user
    @application = current_user&.applications&.find_by(job: @job) if current_user&.candidate?
  end

  def new
    @job = current_user.jobs.build(status: :draft)
  end

  def create
    @job = current_user.jobs.build(job_params)
    authorize @job

    if @job.save
      redirect_to @job, notice: "Job created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @job
  end

  def update
    authorize @job

    if @job.update(job_params)
      redirect_to @job, notice: "Job updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @job
    @job.destroy
    redirect_to jobs_path, notice: "Job deleted."
  end

  private

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(
      :title, :description, :required_skills, :location,
      :employment_type, :min_experience, :salary_range, :status
    )
  end
end

class JobApplicationPolicy < ApplicationPolicy
  def index?
    user.admin? || user.recruiter? || user.candidate?
  end

  def show?
    user.admin? || owns_application? || recruiter_for_job?
  end

  def create?
    user.candidate?
  end

  def update?
    user.admin? || recruiter_for_job?
  end

  def update_status?
    update?
  end

  def recalculate_ats?
    user.admin? || owns_application? || recruiter_for_job?
  end

  private

  def owns_application?
    record.user_id == user.id
  end

  def recruiter_for_job?
    user.recruiter? && record.job.recruiter_id == user.id
  end
end

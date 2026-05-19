class JobPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.admin? || user.recruiter?
  end

  def edit?
    update?
  end

  def update?
    user.admin? || (user.recruiter? && record.recruiter_id == user.id)
  end

  def destroy?
    update?
  end
end

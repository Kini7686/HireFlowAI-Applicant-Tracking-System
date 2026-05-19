class ResumePolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def show?
    user.candidate? && user == record
  end

  def create?
    user.candidate?
  end

  def update?
    user.candidate? && user == record
  end
end

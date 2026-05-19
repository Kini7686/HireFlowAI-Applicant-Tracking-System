class Application < ApplicationRecord
  include Turbo::Broadcastable

  def self.policy_class
    JobApplicationPolicy
  end
  belongs_to :user
  belongs_to :job

  enum status: {
    applied: 0,
    screening: 1,
    interview: 2,
    offer: 3,
    rejected: 4,
    hired: 5
  }

  validates :user_id, uniqueness: { scope: :job_id, message: "has already applied to this job" }
  validate :job_must_be_published, on: :create

  scope :for_recruiter, ->(recruiter) {
    joins(:job).where(jobs: { recruiter_id: recruiter.id })
  }
  scope :with_ats_score, -> { where.not(ats_score: nil) }

  after_create_commit :enqueue_ats_scoring
  after_update_commit :broadcast_status_change, if: :saved_change_to_status?

  def matched_skills_list
    matched_skills.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def missing_skills_list
    missing_skills.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  private

  def job_must_be_published
    errors.add(:job, "must be published to apply") unless job&.published?
  end

  def enqueue_ats_scoring
    AtsScoringJob.perform_later(id)
  end

  def broadcast_status_change
    broadcast_replace_to(
      "application_#{id}",
      target: "application_status_#{id}",
      partial: "applications/status_badge",
      locals: { application: self }
    )
    broadcast_replace_to(
      "recruiter_pipeline",
      target: "pipeline_card_#{id}",
      partial: "recruiter/pipeline/card",
      locals: { application: self }
    )
  end
end

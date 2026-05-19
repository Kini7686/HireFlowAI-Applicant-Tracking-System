class AdminStatsQuery
  def call
    {
      total_users: User.count,
      total_recruiters: User.recruiters.count,
      total_candidates: User.candidates.count,
      total_jobs: Job.count,
      total_applications: Application.count,
      average_ats_score: Application.with_ats_score.average(:ats_score)&.round(2) || 0,
      failed_resume_parses: ResumeProfile.failed_processing.count
    }
  end
end

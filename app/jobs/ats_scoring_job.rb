class AtsScoringJob < ApplicationJob
  queue_as :default

  def perform(application_id)
    application = Application.find(application_id)
    profile = application.user.resume_profile

    unless profile&.ready?
      AtsScoringJob.set(wait: 30.seconds).perform_later(application_id)
      return
    end

    result = AtsScoringService.new(resume_profile: profile, job: application.job).call

    application.update!(
      ats_score: result.score,
      matched_skills: result.matched_skills,
      missing_skills: result.missing_skills,
      ai_feedback: result.feedback
    )

    application.reload

    broadcast_locals = { application: application, show_recalculate: true }

    application.broadcast_replace_to(
      "application_#{application.id}",
      target: "ats_score_#{application.id}",
      partial: "applications/ats_score",
      locals: broadcast_locals
    )

    application.broadcast_replace_to(
      "candidate_applications_#{application.user_id}",
      target: "application_row_#{application.id}",
      partial: "applications/application_row",
      locals: broadcast_locals
    )

    application.broadcast_replace_to(
      "job_applications_#{application.job_id}",
      target: "application_row_#{application.id}",
      partial: "applications/application_row",
      locals: broadcast_locals
    )

    NotificationJob.perform_later(
      application.user_id,
      "ATS score ready",
      "Your application for #{application.job.title} scored #{result.score}%.",
      "ats_score"
    )

    NotificationJob.perform_later(
      application.job.recruiter_id,
      "ATS score generated",
      "#{application.user.name}'s application scored #{result.score}%.",
      "ats_score"
    )
  end
end

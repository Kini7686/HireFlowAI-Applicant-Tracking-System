class ResumeParsingJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    profile = user.resume_profile || user.create_resume_profile!(processing_status: :pending)
    profile.update!(processing_status: :processing, error_message: nil)

    unless user.resume.attached?
      profile.update!(processing_status: :failed, error_message: "No resume attached")
      return
    end

    text = ResumeTextExtractor.new(user.resume).call
    skills = ResumeSkillExtractor.new(text).call
    education = ResumeEducationParser.new(text).call
    experience = ResumeExperienceParser.new(text).call

    profile.update!(
      extracted_text: text,
      parsed_skills: skills,
      parsed_education: education,
      parsed_experience: experience,
      processing_status: :completed,
      error_message: nil
    )

    broadcast_resume_status(profile, user)

    NotificationJob.perform_later(
      user.id,
      "Resume parsed",
      "Your resume has been processed successfully.",
      "resume_parsed"
    )
  rescue StandardError => e
    profile&.update!(processing_status: :failed, error_message: e.message)
    raise
  end

  private

  def broadcast_resume_status(profile, user)
    profile.broadcast_replace_to(
      "resume_profile_#{user.id}",
      target: "resume_processing_status",
      partial: "resumes/processing_status",
      locals: { profile: profile }
    )
  rescue StandardError => e
    Rails.logger.warn("Resume status broadcast failed: #{e.message}")
  end
end

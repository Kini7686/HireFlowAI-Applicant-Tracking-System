class ResumeProfile < ApplicationRecord
  include Turbo::Broadcastable
  belongs_to :user

  enum processing_status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3
  }

  serialize :parsed_skills, coder: JSON
  serialize :parsed_education, coder: JSON
  serialize :parsed_experience, coder: JSON

  scope :failed_processing, -> { where(processing_status: :failed) }

  def skills_list
    Array(parsed_skills).map { |s| s.to_s.downcase.strip }.reject(&:blank?)
  end

  def ready?
    completed? && extracted_text.present?
  end
end

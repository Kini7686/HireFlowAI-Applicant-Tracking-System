class Job < ApplicationRecord
  belongs_to :recruiter, class_name: "User"
  has_many :applications, dependent: :destroy

  enum status: { draft: 0, published: 1, closed: 2 }

  validates :title, :description, presence: true
  validates :min_experience, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :published, -> { where(status: :published) }
  scope :for_recruiter, ->(user) { where(recruiter: user) }

  def required_skills_list
    required_skills.to_s.split(",").map { |s| s.strip.downcase }.reject(&:blank?)
  end
end

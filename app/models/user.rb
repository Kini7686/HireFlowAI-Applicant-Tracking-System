class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, recruiter: 1, candidate: 2 }

  has_one_attached :resume
  has_one :resume_profile, dependent: :destroy
  has_many :jobs, foreign_key: :recruiter_id, dependent: :destroy, inverse_of: :recruiter
  has_many :applications, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validates :role, presence: true

  scope :recruiters, -> { where(role: :recruiter) }
  scope :candidates, -> { where(role: :candidate) }
  scope :admins, -> { where(role: :admin) }

  after_create :build_resume_profile, if: :candidate?

  def admin?
    role == "admin"
  end

  def recruiter?
    role == "recruiter"
  end

  def candidate?
    role == "candidate"
  end

  private

  def build_resume_profile
    create_resume_profile!(processing_status: :pending)
  end
end

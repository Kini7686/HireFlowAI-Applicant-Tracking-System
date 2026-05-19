FactoryBot.define do
  factory :job do
    association :recruiter, factory: [:user, :recruiter]
    title { "Rails Developer" }
    description { "Build great software with Ruby on Rails." }
    required_skills { "ruby, rails, postgresql" }
    location { "Remote" }
    employment_type { "Full-time" }
    min_experience { 2 }
    salary_range { "$90k-$110k" }
    status { :published }
  end
end

puts "Seeding HireFlow AI..."

admin = User.find_or_create_by!(email: "admin@hireflow.ai") do |u|
  u.name = "Admin User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :admin
end

recruiter = User.find_or_create_by!(email: "recruiter@hireflow.ai") do |u|
  u.name = "Riley Recruiter"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :recruiter
end

candidate = User.find_or_create_by!(email: "candidate@hireflow.ai") do |u|
  u.name = "Casey Candidate"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :candidate
end

candidate.resume_profile || candidate.create_resume_profile!(
  processing_status: :completed,
  extracted_text: "Ruby on Rails developer with 5 years experience. Skills: ruby, rails, postgresql, redis, sidekiq, hotwire, rspec, docker, aws.",
  parsed_skills: %w[ruby rails postgresql redis sidekiq hotwire rspec docker aws],
  parsed_education: [{ degree: "B.S. Computer Science" }],
  parsed_experience: [{ years: 5, summary: "Full-stack Rails developer" }]
)

jobs_data = [
  { title: "Senior Rails Developer", description: "Build scalable ATS features with Rails 7 and Hotwire.", required_skills: "ruby, rails, postgresql, redis, sidekiq", location: "Remote", employment_type: "Full-time", min_experience: 3, salary_range: "$120k-$150k", status: :published },
  { title: "Frontend Engineer (Hotwire)", description: "Turbo Frames, Stimulus, and Tailwind UI for hiring workflows.", required_skills: "javascript, hotwire, stimulus, tailwind, rails", location: "New York, NY", employment_type: "Full-time", min_experience: 2, salary_range: "$100k-$130k", status: :published },
  { title: "DevOps Engineer", description: "Docker, AWS, CI/CD for SaaS platform.", required_skills: "docker, kubernetes, aws, ci/cd", location: "Austin, TX", employment_type: "Full-time", min_experience: 4, salary_range: "$110k-$140k", status: :published },
  { title: "Junior Ruby Developer", description: "Learn Rails conventions on a production ATS team.", required_skills: "ruby, rails, rspec, git", location: "Remote", employment_type: "Full-time", min_experience: 0, salary_range: "$70k-$90k", status: :published },
  { title: "Product Manager - Hiring", description: "Own recruiter and candidate experience.", required_skills: "agile, communication, leadership", location: "San Francisco, CA", employment_type: "Full-time", min_experience: 5, salary_range: "$130k-$160k", status: :draft }
]

jobs = jobs_data.map do |attrs|
  recruiter.jobs.find_or_create_by!(title: attrs[:title]) do |j|
    j.assign_attributes(attrs)
  end
end

published_jobs = jobs.select(&:published?)

candidate_two = User.find_or_create_by!(email: "alex@hireflow.ai") do |u|
  u.name = "Alex Applicant"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.role = :candidate
end

applications_data = [
  { user: candidate, job: published_jobs[0], status: :applied, ats_score: 72.5, matched_skills: "ruby, rails, postgresql", missing_skills: "redis", ai_feedback: "Strong Rails background with solid database skills." },
  { user: candidate_two, job: published_jobs[0], status: :screening, ats_score: 85.0, matched_skills: "ruby, rails, redis", missing_skills: "sidekiq", ai_feedback: "Excellent match for senior Rails role." },
  { user: candidate, job: published_jobs[1], status: :interview, ats_score: 68.0, matched_skills: "hotwire, stimulus", missing_skills: "vue", ai_feedback: "Good Hotwire fit." },
  { user: candidate, job: published_jobs[2], status: :rejected, ats_score: 35.0, matched_skills: "docker", missing_skills: "kubernetes", ai_feedback: "Limited DevOps depth." },
  { user: candidate, job: published_jobs[3], status: :offer, ats_score: 90.0, matched_skills: "ruby, rails, rspec", missing_skills: "", ai_feedback: "Outstanding junior Rails candidate." }
]

applications_data.each do |attrs|
  next if attrs[:job].nil?

  Application.find_or_create_by!(user: attrs[:user], job: attrs[:job]) do |a|
    a.status = attrs[:status]
    a.ats_score = attrs[:ats_score]
    a.matched_skills = attrs[:matched_skills]
    a.missing_skills = attrs[:missing_skills]
    a.ai_feedback = attrs[:ai_feedback]
  end
end

puts "Seed complete!"
puts "Admin:    admin@hireflow.ai / password123"
puts "Recruiter: recruiter@hireflow.ai / password123"
puts "Candidate: candidate@hireflow.ai / password123"

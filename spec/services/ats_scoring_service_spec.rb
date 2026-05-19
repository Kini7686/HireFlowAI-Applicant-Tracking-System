require "rails_helper"

RSpec.describe AtsScoringService do
  let(:recruiter) { create(:user, :recruiter) }
  let(:job) do
    create(:job, recruiter: recruiter, required_skills: "ruby, rails, postgresql, redis",
                 min_experience: 3, description: "Senior Rails engineer building scalable systems")
  end
  let(:profile) do
    create(:resume_profile,
           parsed_skills: %w[ruby rails postgresql],
           parsed_experience: [{ years: 5 }],
           extracted_text: "Experienced rails developer building scalable systems")
  end

  subject(:result) { described_class.new(resume_profile: profile, job: job).call }

  it "returns a score between 0 and 100" do
    expect(result.score).to be_between(0, 100)
  end

  it "identifies matched skills" do
    expect(result.matched_skills).to include("ruby")
    expect(result.matched_skills).to include("rails")
  end

  it "identifies missing skills" do
    expect(result.missing_skills).to include("redis")
  end

  it "generates feedback" do
    expect(result.feedback).to be_present
  end
end

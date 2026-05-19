require "rails_helper"

RSpec.describe Job, type: :model do
  describe "validations" do
    subject { build(:job) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe "enums" do
    it "defines status values" do
      expect(Job.statuses.keys).to match_array(%w[draft published closed])
    end
  end

  describe "#required_skills_list" do
    it "parses comma-separated skills" do
      job = build(:job, required_skills: "Ruby, Rails, PostgreSQL")
      expect(job.required_skills_list).to eq(%w[ruby rails postgresql])
    end
  end
end

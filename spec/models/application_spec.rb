require "rails_helper"

RSpec.describe Application, type: :model do
  describe "uniqueness" do
    it "allows only one application per user per job" do
      existing = create(:application)
      duplicate = build(:application, user: existing.user, job: existing.job)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("has already applied to this job")
    end
  end
end

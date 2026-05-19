require "rails_helper"

RSpec.describe User, type: :model do
  describe "roles" do
    it "defines admin, recruiter, and candidate roles" do
      expect(User.roles.keys).to match_array(%w[admin recruiter candidate])
    end

    it "defaults to candidate role" do
      user = described_class.new(name: "Test", email: "t@example.com", password: "password123")
      expect(user.role).to eq("candidate")
    end

    it "provides role predicate methods" do
      admin = build(:user, :admin)
      recruiter = build(:user, :recruiter)
      candidate = build(:user, :candidate)

      expect(admin.admin?).to be true
      expect(recruiter.recruiter?).to be true
      expect(candidate.candidate?).to be true
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end
end

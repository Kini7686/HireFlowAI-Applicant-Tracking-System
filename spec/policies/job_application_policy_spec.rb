require "rails_helper"

RSpec.describe JobApplicationPolicy do
  subject { described_class.new(user, application) }

  let(:recruiter) { create(:user, :recruiter) }
  let(:candidate) { create(:user, :candidate) }
  let(:other_candidate) { create(:user, :candidate, email: "other@example.com") }
  let(:job) { create(:job, recruiter: recruiter) }
  let(:application) { create(:application, user: candidate, job: job) }

  context "as candidate owner" do
    let(:user) { candidate }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:recalculate_ats) }
    it { is_expected.to forbid_action(:update) }
  end

  context "as recruiter for job" do
    let(:user) { recruiter }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:recalculate_ats) }
    it { is_expected.to permit_action(:update) }
  end

  context "as other candidate" do
    let(:user) { other_candidate }

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:recalculate_ats) }
  end
end

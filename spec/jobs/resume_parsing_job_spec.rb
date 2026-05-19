require "rails_helper"

RSpec.describe ResumeParsingJob, type: :job do
  let(:candidate) { create(:user, :candidate) }

  before do
    candidate.resume_profile.update!(processing_status: :pending)
  end

  it "marks profile as failed when no resume attached" do
    described_class.perform_now(candidate.id)
    expect(candidate.resume_profile.reload.failed?).to be true
    expect(candidate.resume_profile.error_message).to eq("No resume attached")
  end
end

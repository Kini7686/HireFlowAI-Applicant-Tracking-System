FactoryBot.define do
  factory :resume_profile do
    association :user, factory: [:user, :candidate]
    processing_status { :completed }
    parsed_skills { %w[ruby rails] }
    parsed_education { [{ degree: "B.S. CS" }] }
    parsed_experience { [{ years: 3 }] }
    extracted_text { "Ruby on Rails developer" }
  end
end

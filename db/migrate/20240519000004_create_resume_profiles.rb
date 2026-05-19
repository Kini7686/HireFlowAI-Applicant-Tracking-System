class CreateResumeProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :resume_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :extracted_text
      t.text :parsed_skills
      t.text :parsed_education
      t.text :parsed_experience
      t.integer :processing_status, null: false, default: 0
      t.text :error_message

      t.timestamps
    end

    add_index :resume_profiles, :processing_status
  end
end

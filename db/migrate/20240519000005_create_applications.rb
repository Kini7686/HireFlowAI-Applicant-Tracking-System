class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.decimal :ats_score, precision: 5, scale: 2
      t.text :matched_skills
      t.text :missing_skills
      t.text :ai_feedback
      t.text :recruiter_notes

      t.timestamps
    end

    add_index :applications, %i[user_id job_id], unique: true
    add_index :applications, :status
  end
end

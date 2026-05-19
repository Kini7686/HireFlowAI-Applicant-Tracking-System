class CreateJobs < ActiveRecord::Migration[7.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :required_skills
      t.string :location
      t.string :employment_type
      t.integer :min_experience, default: 0
      t.string :salary_range
      t.integer :status, null: false, default: 0
      t.references :recruiter, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :jobs, :status
  end
end

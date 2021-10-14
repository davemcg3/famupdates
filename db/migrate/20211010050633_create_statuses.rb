class CreateStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :statuses do |t|
      t.text :content
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end

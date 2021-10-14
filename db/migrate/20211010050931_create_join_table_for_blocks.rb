class CreateJoinTableForBlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :blocked do |t|
      t.references :blocker, index: true, foreign_key:{to_table: :profiles}
      t.references :blocked, index: true, foreign_key:{to_table: :profiles}

      t.timestamps

      # t.index [:profile_id, :profile_id]
      # t.index [:profile_id, :profile_id]
    end
  end
end

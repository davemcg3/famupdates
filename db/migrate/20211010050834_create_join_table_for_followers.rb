class CreateJoinTableForFollowers < ActiveRecord::Migration[6.1]
  def change
    create_table :followers do |t|
      t.references :follower, index: true, foreign_key:{to_table: :profiles}
      t.references :followed, index: true, foreign_key:{to_table: :profiles}

      t.timestamps

      # t.index [:profile_id, :profile_id]
      # t.index [:profile_id, :profile_id]
    end
  end
end

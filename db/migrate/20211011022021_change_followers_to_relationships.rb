class ChangeFollowersToRelationships < ActiveRecord::Migration[6.1]
  def change
    rename_table :followers, :relationships
  end
end

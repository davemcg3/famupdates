class RenameBlocksToExclusions < ActiveRecord::Migration[6.1]
  def change
    rename_table :blocked, :exclusions
  end
end

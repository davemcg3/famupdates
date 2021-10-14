class AddLastLoadedToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :last_loaded, :datetime
  end
end

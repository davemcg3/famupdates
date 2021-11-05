class AddUsernameToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :username, :string
    add_index :profiles, :username, unique: true
  end
end

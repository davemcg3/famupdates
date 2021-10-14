class ChangeProfilesUsersToProfileUsers < ActiveRecord::Migration[6.1]
  def change
    rename_table :profiles_users, :profile_users
  end
end

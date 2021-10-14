class ChangeProfileUsersToProfilesUsers < ActiveRecord::Migration[6.1]
  def change
    rename_table :profile_users, :profiles_users
  end
end

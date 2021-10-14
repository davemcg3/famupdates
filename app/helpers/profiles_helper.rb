module ProfilesHelper
  def get_block_path_helper(current_profile, profile)
    return nil if current_profile == profile

    return button_to 'Unblock', exclusion_path(profile), method: :delete if current_profile.blocking?(profile)

    button_to 'Block', exclusions_path(blocked_id: profile.id)
  end

  def get_follow_path_helper(current_profile, profile)
    return nil if current_profile == profile

    return button_to 'Unfollow', relationship_path(profile), method: :delete if current_profile.following?(profile)

    button_to 'Follow', relationships_path(followed_id: profile.id)
  end
end

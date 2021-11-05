module ApplicationHelper
  def navbar_user_link
    if current_user.present?
      return link_to "Logout", destroy_user_session_path, :method => :delete
    else
      link_to "Login", new_user_session_path
    end
  end

  def display_linked_profile_name(profile)
    link_to profile.name, profile_path(profile)
  end

  def profile_name_with_fallback(current_user)
    current_user.profiles&.first&.name || current_user.profiles&.first&.username || current_user.email
  end
end

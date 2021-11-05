class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    profiles = current_user.profiles # empty array on account creation
    # logger.debug profiles.inspect
    # logger.debug profiles.empty?
    if profiles.empty?
      # logger.debug current_user.inspect
      # profiles = [ProfileService.new(current_user).create(name: current_user.email)]
      # logger.debug profiles.inspect
      return new_profile_path
    elsif profiles.first.username.nil?
      return edit_profile_path(profiles.first)
    end

    # logger.debug profiles.inspect
    # profiles.map{|p| logger.debug p.kind_of?(Profile)}
    profile_last_loaded = profiles.map{|p| p[:last_loaded].to_i}
    load_profile_path(profiles[profile_last_loaded.index(profile_last_loaded.max)].id) || stored_location_for(resource) || request.referer || root_path
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to root_path, notice: (t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default)
  end
end

class RelationshipsController < ApplicationController
  # before_action :logged_in_user

  def create
    profile = Profile.find(params[:followed_id])
    current_user.profiles.first.follow(profile)
    respond_to do |format|
      format.html { redirect_to profile }
      format.js
    end
  end

  def destroy
    # profile = Relationship.find(params[:id]).followed
    profile = Profile.find(params[:id])
    current_user.profiles.first.unfollow(profile)
    respond_to do |format|
      format.html { redirect_to profile }
      format.js
    end
  end
end

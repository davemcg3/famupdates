class ExclusionsController < ApplicationController
  # before_action :logged_in_user

  def create
    profile = Profile.find(params[:blocked_id])
    current_user.profiles.first.block(profile)
    respond_to do |format|
      format.html { redirect_to profile }
      format.js
    end
  end

  def destroy
    # profile = Exclusion.find(params[:id]).blocked
    profile = Profile.find(params[:id])
    current_user.profiles.first.unblock(profile)
    respond_to do |format|
      format.html { redirect_to profile }
      format.js
    end
  end
end

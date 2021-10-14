class SiteController < ApplicationController
  before_action :check_auth, only: %i[ index ]

  # GET /site or /site.json
  def index; end

  def terms_of_use; end

  def privacy_policy; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def check_auth
    redirect_to logged_in_homepage_path if current_user.present?
  end
end

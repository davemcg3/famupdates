class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[ show edit update destroy friends statuses ]

  # GET /profiles or /profiles.json
  def index
    @profiles = current_user.profiles.first.unblocked
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    @posts = Post.by_user(@profile)
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    authorize @profile
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        current_user.profiles << @profile
        # format.html { redirect_to @profile, notice: "Profile was successfully created." }
        format.html { redirect_to profiles_path, notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    authorize @profile
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    authorize @profile
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def load_profile
    # Rails.logger.debug params
    session[:current_profile] = Profile.find(params[:id])
    # Rails.logger.debug session[:current_profile].inspect
    session[:current_profile][:last_loaded] = Time.zone.now
    session[:current_profile].save
    respond_to do |format|
      format.html {
        if (params[:forward])
          redirect_to params[:forward], notice: 'Profile loaded.'
        else
          redirect_to logged_in_homepage_path, notice: 'Profile loaded.'
        end
      }
      format.json { head :no_content }
    end
  end

  # GET /profiles/friends or /profiles/friends.json
  def friends
    # TODO: `first` is a hack, fix it
    # @current_user_latest_status = Status.where(profile: current_user.profiles.first).order("id DESC").limit(1).first
    # current user follows [profile, profile, ...]
    # @following = current_user.profiles.first.following
    # statusus = Status.where(profile: in array), group by max id
    # @statuses = Status.where(profile: )
  end

  # GET /profiles/1/statuses or /profiles/1/statuses.json
  def statuses
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    begin
      # profile_to_find = params[:id] || current_user.profiles.first.id
      # @profile = Profile.find(profile_to_find)
      # This will also grab an id as the username param if an id was sent instead of a username in the route
      profile_to_find = params[:username] || current_user.profiles.first&.username
      begin
        @profile = Profile.find_by!(username: profile_to_find)
      rescue ActiveRecord::RecordNotFound => e
        @profile = Profile.find(profile_to_find) # try as an id
      end
    rescue ActiveRecord::RecordNotFound => e
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  # Only allow a list of trusted parameters through.
  def profile_params
    params.require(:profile).permit(:name, :bio, :username)
  end
end

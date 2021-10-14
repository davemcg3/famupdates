class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :load_profile, only: %i[ new edit ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all.where(profile: current_user.profiles.first.all_not_blocked)
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    authorize @post
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params.merge({author_id: current_user.profiles.first.id}))

    respond_to do |format|
      if @post.save
        format.html { redirect_to Profile.find(post_params[:profile_id]), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    authorize @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    Rails.logger.debug 'about to authorize'
    authorize @post
    Rails.logger.debug 'authorized'
    @post.destroy
    Rails.logger.debug 'destroyed'
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # TODO: investigate if this should be used for profiles and statuses to prevent other users from editing
  # TODO: or check if it's preventing editing here because it was designed for create only
  def load_profile
    redirect_to logged_in_homepage_path and return if params[:profile_id].blank?

    @profile = Profile.find(params[:profile_id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:content, :profile_id, :author_id)
  end
end

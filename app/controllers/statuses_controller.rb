class StatusesController < ApplicationController
  before_action :set_status, only: %i[ show edit update destroy ]

  # GET /statuses or /statuses.json
  def index
    @statuses = Status.all.where(profile: current_user.profiles.first.all_not_blocked)
  end

  # GET /statuses/1 or /statuses/1.json
  def show
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
    authorize @status
  end

  # POST /statuses or /statuses.json
  def create
    @status = Status.new(status_params.merge({profile_id: current_user.profiles.first.id}))

    respond_to do |format|
      if @status.save
        format.html { redirect_to logged_in_homepage_path, notice: "Status was successfully created." }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1 or /statuses/1.json
  def update
    authorize @status
    respond_to do |format|
      if @status.update(status_params)
        format.html { redirect_to @status, notice: "Status was successfully updated." }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1 or /statuses/1.json
  def destroy
    authorize @status
    @status.destroy
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: "Status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status
      @status = Status.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def status_params
      params.require(:status).permit(:content, :profile_id)
    end
end

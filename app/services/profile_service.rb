class ProfileService
  # content is a collection
  attr_reader :profile
  attr_reader :status
  attr_reader :errors

  def initialize current_user
    @current_user = current_user
  end

  def create passed_params=nil
    if passed_params.nil?
      @errors = "No info passed"
      return false
    end

    # passed_params should be site_id, collection_group, name
    Rails.logger.debug "ProfileService.create passed_params: #{passed_params.inspect}"
    @profile = Profile.new(passed_params)
    if @profile.save
      @current_user.profiles << @profile
      @status = "ok"
    else
      @status = "not ok"
      @errors = "failed to create profile"
      @profile = false
    end

    @profile
  end
end

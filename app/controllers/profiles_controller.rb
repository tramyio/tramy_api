class ProfilesController < ApplicationController
  def show
    render json: ProfileSerializer.new(profile).serializable_hash[:data][:attributes]
  end

  def update
    if profile.update(profile_params)
      render json: profile
    else
      render json: profile.errors, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def profile_params
    params.require(:profile).permit(:first_name, :last_name)
  end

  def profile
    @profile ||= current_user.profile
  end
end

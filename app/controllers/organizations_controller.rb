# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show update]

  # GET /organizations/1
  def show
    render json: @organization
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization, status: :created, location: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/1
  def update
    if @organization.update(update_organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = current_user.organization
  end

  # Only allow a trusted parameter "white list" through.
  def organization_params
    params.require(:organization).permit(:name, :phone, :address, :domain, :provider_api_key)
  end

  def update_organization_params
    params.require(:organization).permit(:name, :address, :domain)
  end
end

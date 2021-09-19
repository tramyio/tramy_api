# frozen_string_literal: true

class OrganizationsController < ApplicationController
  # TODO: Convert to role admin when user creates organization (https://github.com/tramyio/tramy_api/issues/15)

  before_action :set_organization, only: %i[show update]

  def show
    render json: SafeOrganizationSerializer.new(@organization).serializable_hash[:data][:attributes]
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      render json: @organization, status: :created
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  def update
    if @organization.update(update_organization_params)
      render json: @organization
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  private

  def set_organization
    @organization = current_user.organization
  end

  def organization_params
    params.require(:organization).permit(:name, :phone, :address, :domain, :provider_api_key)
  end

  def update_organization_params
    params.require(:organization).permit(:name, :address, :domain)
  end
end

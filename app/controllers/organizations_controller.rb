# frozen_string_literal: true

class OrganizationsController < ApplicationController
  # TODO: Convert to role admin when user creates organization (https://github.com/tramyio/tramy_api/issues/15)

  before_action :set_organization, only: %i[show update]

  def show
    if @organization.nil?
      render json: 'This account does not belong to a valid organization',
             status: :not_found
    else
      safe_render(@organization)
    end
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
      safe_render(@organization)
    else
      render json: @organization.errors, status: :unprocessable_entity
    end
  end

  def safe_render(organization)
    render json: SafeOrganizationSerializer.new(organization).serializable_hash[:data][:attributes]
  end

  private

  def set_organization
    @organization = current_user.organization
  end

  def organization_params
    params.require(:organization).permit(:name, :address, :domain, :provider_api_key, :phone)
  end

  def update_organization_params
    # Do not allow allow user updates api_key or phone !
    params.require(:organization).permit(:name, :address, :domain)
  end
end

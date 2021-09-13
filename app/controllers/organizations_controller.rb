# frozen_string_literal: true

class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[show update]

  def show
    render json: @organization
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      render json: @organization, status: :created, location: @organization
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

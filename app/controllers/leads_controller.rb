# frozen_string_literal: true

class LeadsController < ApplicationController
  # TODO: Fix vulnerability issue in case user try to update lead to another organization
  before_action :set_lead, only: %i[show update destroy]

  # GET /leads
  def index
    @leads = Lead.oldest_created

    render json: @leads
  end

  # GET /leads/1
  def show
    render json: @lead
  end

  # POST /leads
  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      render json: @lead, status: :created, location: @lead
    else
      render json: @lead.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leads/1
  def update
    if @lead.update(lead_params)
      render json: @lead
    else
      render json: @lead.errors, status: :unprocessable_entity
    end
  end

  # DELETE /leads/1
  # def destroy
  #   @lead.destroy
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lead
    @lead = Lead.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def lead_params
    params.require(:lead).permit(:stage_id, :name, :email, :phone,
                                 :organization_id).with_defaults(organization_id: current_user.organization.id)
  end
end

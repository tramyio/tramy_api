# frozen_string_literal: true

class LeadsController < ApplicationController
  # TODO: Fix vulnerability issue in case user try to update lead to another organization
  before_action :set_lead, only: %i[show update]
  before_action :set_organization, only: %i[index list_pipeline_stage_leads]

  def index
    @leads = @organization.leads.recently_created

    render json: LeadSerializer.new(@leads).serializable_hash[:data]
  end

  def list_pipeline_stage_leads
    @pipeline = @organization.pipelines.find(params[:pipeline_id])
    render json: PipelineStageLeadSerializer.new(@pipeline).serializable_hash[:data][:attributes]
  rescue StandardError
    render json: 'You do not have access to this pipeline or pipeline_id does not exist'
  end

  def show
    return unless permitted_lead(@lead)

    render json: @lead
  end

  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      render json: @lead, status: :created
    else
      render json: @lead.errors, status: :unprocessable_entity
    end
  end

  def update
    return unless permitted_lead(@lead)

    if @lead.update(lead_params)
      render json: @lead
    else
      render json: @lead.errors, status: :unprocessable_entity
    end
  end

  def permitted_lead(lead)
    current_user.organization == lead.organization
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lead
    @lead = Lead.find(params[:id])
  end

  def set_organization
    @organization = current_user.organization
  end

  # Only allow a trusted parameter "white list" through.
  def lead_params
    params.require(:lead).permit(:stage_id, :name, :email, :phone,
                                 :organization_id).with_defaults(organization_id: current_user.organization.id)
  end
end

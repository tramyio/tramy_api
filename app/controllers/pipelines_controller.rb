# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :set_pipeline, only: %i[show update destroy]
  before_action :set_organization, only: %i[list_pipeline_stage_leads]

  def index
    @pipelines = Pipeline.includes(:stages).where(organization: current_user.organization)

    render json: PipelineSerializer.new(@pipelines).serializable_hash[:data]
  end

  def list_pipeline_stage_leads
    @pipeline = @organization.pipelines.find(params[:pipeline_id])
    render json: PipelineStageLeadSerializer.new(@pipeline).serializable_hash[:data][:attributes]
  rescue StandardError => e
    render json: "Pipeline not allowed or wrong id, error: #{e}"
  end

  def create
    @pipeline = Pipeline.new(pipeline_params)

    if @pipeline.save
      render json: @pipeline, status: :created
    else
      render json: @pipeline.errors, status: :unprocessable_entity
    end
  end

  def update
    # TODO: Add Pundit
    if @pipeline.update(pipeline_params)
      render json: @pipeline
    else
      render json: @pipeline.errors, status: :unprocessable_entity
    end
  end

  # TODO: Add Pundit
  # def destroy
  #   @pipeline.destroy
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pipeline
    @pipeline = Pipeline.find(params[:id])
  end

  def set_organization
    @organization = current_user.organization
  end

  # Only allow a trusted parameter "white list" through.
  def pipeline_params
    params.require(:pipeline)
          .permit(:name, :organization_id)
          .with_defaults(organization_id: current_user.organization.id)
  end
end

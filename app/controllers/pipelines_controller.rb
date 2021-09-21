# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :set_pipeline, only: %i[show update destroy]

  def index
    @pipelines = Pipeline.includes(:stages).where(organization: current_user.organization)

    render json: PipelineSerializer.new(@pipelines).serializable_hash[:data]
  end

  # GET /pipelines/1
  # def show
  #   # TODO: Add Pundit
  #   render json: @pipeline
  # end

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

  # Only allow a trusted parameter "white list" through.
  def pipeline_params
    params.require(:pipeline).permit(:name,
                                     :organization_id).with_defaults(organization_id: current_user.organization.id)
  end
end

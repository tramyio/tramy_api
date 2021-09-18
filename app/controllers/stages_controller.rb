# frozen_string_literal: true

class StagesController < ApplicationController
  before_action :set_stage, only: %i[update destroy]

  def index
    @stages = Stage.joins(:pipeline).merge(Pipeline.where(organization_id: current_user.organization))
    render json: @stages
  end

  def create
    @stage = Stage.new(stage_params)

    if @stage.save
      render json: @stage, status: :created, location: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  def update
    return unless permitted_stage(@stage)

    if @stage.update(update_stage_params)
      render json: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @stage.destroy
  end

  def permitted_stage(stage)
    (current_user.organization == stage.pipeline.organization)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stage
    @stage = Stage.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def stage_params
    params.require(:stage).permit(:name, :pipeline_id)
  end

  def update_stage_params
    params.require(:stage).permit(:name)
  end
end

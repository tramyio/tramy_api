class StagesController < ApplicationController
  before_action :set_stage, only: [:show, :update, :destroy]

  # GET /stages
  def index
    @stages = Stage.all

    render json: @stages
  end

  # GET /stages/1
  def show
    render json: @stage
  end

  # POST /stages
  def create
    @stage = Stage.new(stage_params)

    if @stage.save
      render json: @stage, status: :created, location: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stages/1
  def update
    if @stage.update(stage_params)
      render json: @stage
    else
      render json: @stage.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stages/1
  def destroy
    @stage.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stage
      @stage = Stage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stage_params
      params.require(:stage).permit(:index, :create, :update, :destroy)
    end
end

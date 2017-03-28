class V3::ListsController < V3::BaseController
  before_action :set_list, only: [:show, :update, :destroy]

  # GET /v3/lists
  def index
    @lists = List.all
    if stale?(@lists)
      render json: @lists
    end
  end

  # GET /v3/lists/1
  def show
    if stale?(@list)
      render json: @list
    end
  end

  # POST /v3/lists
  def create
    @list = List.new(list_params)

    if @list.save
      render json: @list,
             status: :created,
             location: v3_list_url(@list)
    else
      respond_with_validation_error @list
    end
  end

  # PATCH/PUT /v3/lists/1
  def update
    if @list.update(list_params)
      render json: @list
    else
      respond_with_validation_error @list
    end
  end

  # DELETE /v3/lists/1
  def destroy
    @list.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = List.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def list_params
    params.require(:list).permit(:board_id, :creator_id, :title, :archived)
  end
end

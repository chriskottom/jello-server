class V4::BoardsController < V4::BaseController
  before_action :set_user, only: [:index]
  before_action :set_board, only: [:show, :update, :destroy]

  # GET /v4/boards
  def index
    @boards = (@user ? @user.boards : Board.all)
    if stale?(@boards)
      render json: @boards
    end
  end

  # GET /v4/boards/1
  def show
    if stale?(@board)
      render json: @board
    end
  end

  # POST /v4/boards
  def create
    @board = Board.new(board_params)

    if @board.save
      render json: @board,
             status: :created,
             location: v4_board_url(@board)
    else
      respond_with_validation_error @board
    end
  end

  # PATCH/PUT /v4/boards/1
  def update
    if @board.update(board_params)
      render json: @board
    else
      respond_with_validation_error @board
    end
  end

  # DELETE /v4/boards/1
  def destroy
    @board.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def set_board
    @board = Board.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def board_params
    params.require(:board).permit(:creator_id, :title, :archived)
  end
end

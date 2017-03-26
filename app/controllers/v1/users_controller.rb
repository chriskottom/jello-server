class V1::UsersController < V1::BaseController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /v1/users
  def index
    @users = User.all
    if stale?(@users)
      render json: @users, include: []
    end
  end

  # GET /v1/users/1
  def show
    if stale?(@user)
      render json: @user, include: [:active_boards]
    end
  end

  # POST /v1/users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user,
             status: :created,
             location: v1_user_url(@user)
    else
      respond_with_validation_error @user
    end
  end

  # PATCH/PUT /v1/users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      respond_with_validation_error @user
    end
  end

  # DELETE /v1/users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    params
      .require(:user)
      .permit(:email, :password, :password_confirmation, :admin)
  end
end

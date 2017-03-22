class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    @users = User.all
    if stale?(@users)
      render json: @users, include: []
    end
  end

  # GET /users/1
  def show
    if stale?(@user)
      render json: @user, include: [:active_boards]
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      respond_with_validation_error @user
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      respond_with_validation_error @user
    end
  end

  # DELETE /users/1
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

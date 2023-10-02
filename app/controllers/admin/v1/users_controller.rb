module Admin::V1
  class UsersController < ApiController
    before_action :find_user, only: [:update, :destroy]

    def index
      @users = User.where.not(id: @current_user.id)
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render :show, status: :created
      else
        render_error(fields: @user.errors.messages)
      end
    end

    def update
      if @user.update(user_params)
        render :show
      else
        render_error(fields: @user.errors.messages)
      end
    end

    def destroy
      begin
        @user.destroy
      rescue
        render_error(fields: @user.errors.messages)
      end
    end

    private

    def user_params
      params
        .require(:user)
        .permit(:id, :name, :email, :password, :password_confirmation, :profile)
    end

    def find_user
      @user = User.find(params[:id])
    end
  end
end
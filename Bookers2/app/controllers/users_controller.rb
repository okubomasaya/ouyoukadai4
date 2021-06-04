class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_current_user, only: [:edit, :update]

    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
        @books = @user.books
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update(user_params)
            flash[:notice] = "You have updated user successfully."
            redirect_to user_path(@user.id)
        else
            render ("/users/edit")
        end
    end

    private
    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def check_current_user
        unless User.find(params[:id]) == current_user
            redirect_to user_path(current_user.id)
        end
    end
end

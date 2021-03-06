module Api
  module V1
    class UsersController < ApplicationController
      def index
        @users = User.all
        render json: @users, serializer: ActiveModel::ArraySerializer, each_serializer: UserSerializer
      end

      def show
        @user = User.find(params[:id])
        render json: @user, serializer: UserSerializer
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: 201, location: [:api, @user]
        else
          render json: { errors: @user.errors }, status: 422
        end
      end

      def update
        @user = current_user

        if @user.update(user_params)
          render json: @user, status: 200, location: [:api, @user]
        else
          render json: { errors: @user.errors }, status: 422
        end
      end

      def destroy
        @user = current_user

        if @user.destroy
          head(200)
        else
          head(422)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end


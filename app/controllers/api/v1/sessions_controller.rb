class Api::V1::SessionsController < ApplicationController
  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user.valid_password?(user_password)
      sign_in(user, store: false)
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    @user = User.find_by(authentication_token: params[:id])
    if sign_out(@user)
      head(200)
    else
      head(422)
    end
  end
end

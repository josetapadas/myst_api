module Authenticable
  def current_user
    @current_user ||= User.find_by(authentication_token: request.headers['Authorization'])
  end

    def authenticate!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless current_user.present?
  end
end

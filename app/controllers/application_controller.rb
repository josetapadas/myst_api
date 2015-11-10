class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CanCan::ControllerAdditions
  include Authenticable

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: 'Access Denied' }, status: 401
  end
end

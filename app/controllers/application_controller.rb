class ApplicationController < ActionController::API

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  def is_librarian?
    render json: { message: 'librarian only, not authorized' }, status: :unauthorized unless current_user.librarian?
  end



  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[librarian])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[librarian])
  end
end

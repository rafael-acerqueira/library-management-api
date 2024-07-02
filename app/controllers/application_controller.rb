class ApplicationController < ActionController::API

  before_action :authenticate_user!

  def is_librarian?
    render json: { message: 'librarian only, not authorized' }, status: :unauthorized unless current_user.librarian?
  end
end

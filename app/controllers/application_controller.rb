class ApplicationController < ActionController::API
  respond_to :json

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  # get the Header and decode the jwt token
  # find the user by the token
  # set the @current_user
  # if the user is not found, return an unauthorized error
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = Warden::JWTAuth::TokenDecoder.new.call(header)
      Rails.logger.info "Decoded token: #{decoded}"
      @current_user = User.find(decoded['sub'])
    rescue => e
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end

module Api
  class SessionsController < ApplicationController
    respond_to :json

    def create
      user = User.find_by(email: params[:email])

      if user && user.valid_password?(params[:password])
        token = generate_jwt_for(user)

        render json: { token: token }
      else
        render json: { error: 'Invalid email or password.' }, status: :unauthorized
      end
    end

    private

    def generate_jwt_for(user)
      # generate a jwt token for the user
      Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    end
  end
end
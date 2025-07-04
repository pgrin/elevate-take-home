module Api
  class UsersController < ApplicationController
    before_action :authorize_request, only: [:show]

    def create
      if User.find_by(email: params[:email])
        render json: { errors: "User already exists" }, status: :unprocessable_entity
        return
      end

      User.create!(email: params[:email], password: params[:password], password_confirmation: params[:password])
      render status: :created
    end

    def show
      subscription_status = SubscriptionService.get_subscription_status(@current_user)
      render json: { user: { id: @current_user.id, email: @current_user.email, stats: {total_games_played: @current_user.game_events.count, subscription_status: subscription_status} } }
    end
  end
end

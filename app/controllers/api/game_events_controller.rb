module Api
  class GameEventsController < ApplicationController
    before_action :authorize_request

    def create
      # validate the request body
      event_params = params.require(:game_event).permit(:game_name, :type, :occurred_at)

      required_fields = %i[game_name type occurred_at]
      missing_fields = required_fields.select { |field| event_params[field].blank? }

      # return an error if any required fields are missing
      if missing_fields.any?
        return render json: { error: "Missing required fields: #{missing_fields.join(', ')}" }, status: :unprocessable_entity
      end

      # return an error if the type is not 'COMPLETED'
      unless event_params[:type] == 'COMPLETED'
        return render json: { error: "Invalid type. Only 'COMPLETED' is allowed." }, status: :unprocessable_entity
      end

      # create the game event from params
      @current_user.game_events.create!(
        game_name: event_params[:game_name],
        event_type: event_params[:type],
        occurred_at: event_params[:occurred_at]
      )

      render status: :created
    end
  end
end
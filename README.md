# README

DB Schema - db/schema.rb
Tables
users - email, encrypted_password, reset_password_token, various timestamps
game_events - game_name, occurred_at, event_type, user_id (foreign key to users table), timestamps

Models
user.rb
game_event.rb

Routes - config/routes.rb
/api/sessions - POST
/api/user - GET, POST
/api/user/game_events - POST

Controllers
users_controller.rb
create - Creates a user in the db with the email/password from the request body
show - shows the user info and stats
sessions_controller.rb
create - verifies the email/password and generates a jwt token using the User model
game_events_controller.rb
create - authorizes the user, verifies the request body to contain all the required fields and creates a GameEvent in the db

Notes:
I used devise and devise-jwt gems to handle authorization. The user model uses these gems to encrypt the password in the db, and generate and authenticate with session JWT tokens.

SubcriptionService - services/subscription_service.rb
Using the faraday gem, I create a connection to the external API if not doesnt already exist.
Call the API with a jwt token stored in Rails.application.credentials
Using the id from the User model for the subcription service
The connection is set up to retry up to 3 times for status codes 500-599
Since the service recalculates the subscription status of users every 24h. I chose not to cache the results for 1 hr. This way the user will only have additional access to the service for at most an hour after their subscription has expired. Cache is stored in memory.

To start the service run:
rails db:migrate
rails server

To run tests
rails test

class User < ApplicationRecord
  has_many :game_events

  # Devise configuration
  # database_authenticatable:
  #   Store an encrypted password in the database.
  #   Handle password hashing using bcrypt behind the scenes.
  # jwt_authenticatable:
  #   This tells Devise to authenticate users using JWT tokens.
  #   Instead of using session cookies, the user sends a JWT token in the Authorization header for every request.
  # jwt_revocation_strategy:
  #   Use Null strategy for JWT revocation.
  #   The token is valid until it expires.
  devise :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validates :email, :password, presence: true
end
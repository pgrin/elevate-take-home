# README

## Database Schema
**File:** `db/schema.rb`

### Tables
- **users**
  - `email`
  - `encrypted_password`
  - `reset_password_token`
  - Timestamps (`created_at`, `updated_at`)

- **game_events**
  - `game_name`
  - `occurred_at`
  - `event_type`
  - `user_id` (foreign key to users table)
  - Timestamps (`created_at`, `updated_at`)

---

## Models
- `user.rb`
- `game_event.rb`

---

## Routes
**Defined in:** `config/routes.rb`

| HTTP Verb | Path                     | Action                     |
|-----------|--------------------------|----------------------------|
| POST      | `/api/sessions`          | User login                 |
| GET, POST | `/api/user`              | User info/stats and registration |
| POST      | `/api/user/game_events`  | Game event creation        |

---

## Controllers

### `users_controller.rb`
- **`create`**
  - Creates a user in the database using the email and password from the request body.
  
- **`show`**
  - Returns user information and game statistics.

---

### `sessions_controller.rb`
- **`create`**
  - Verifies email and password.
  - Generates a JWT token using the `User` model.

---

### `game_events_controller.rb`
- **`create`**
  - Authorizes the user.
  - Validates required fields in the request body.
  - Creates a `GameEvent` in the database.

---

## Authentication & Authorization
- Uses `devise` and `devise-jwt` gems:
  - Encrypts passwords in the database.
  - Generates JWT tokens for session management.
  - Authenticates API requests using JWT tokens.

---

## Services

### `services/subscription_service.rb`
- Uses **Faraday** to call an external API.
- Connection is memoized (persisted across requests).
- Sends JWT token from `Rails.application.credentials`.
- Uses the `User` model’s ID to fetch subscription status.
- Automatically **retries** up to 3 times on HTTP 5xx errors.
- **Caching:**
  - Subscription status is cached for **1 hour** based on user's ID.
  - Uses Rails' in-memory cache store.
---

## Create the db (local sqllite)
```bash
rails db:migrate
```
---

## Running the Service
```bash
rails server
```
---

## Testing
```bash
rails test
```

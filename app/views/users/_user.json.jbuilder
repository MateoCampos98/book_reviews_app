json.extract! user, :id, :email, :user_name, :full_name, :status, :created_at, :updated_at
json.url user_url(user, format: :json)

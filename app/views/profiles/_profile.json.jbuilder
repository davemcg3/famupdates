json.extract! profile, :id, :name, :bio, :created_at, :updated_at
json.url profile_url(profile, format: :json)

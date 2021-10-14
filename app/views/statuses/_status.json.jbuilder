json.extract! status, :id, :content, :profile_id, :created_at, :updated_at
json.url status_url(status, format: :json)

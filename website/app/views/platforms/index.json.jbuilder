json.array!(@platforms) do |platform|
  json.extract! platform, :id, :kind, :token, :name, :user_id
  json.url platform_url(platform, format: :json)
end

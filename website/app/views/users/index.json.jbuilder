json.array!(@users) do |user|
  json.extract! user, :id, :name, :password, :admin_rank
  json.url user_url(user, format: :json)
end

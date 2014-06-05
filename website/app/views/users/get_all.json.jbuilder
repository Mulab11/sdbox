json.extract! @user, :id, :name
json.platforms do
  json.array!(@user.platforms) do |platform|
    json.extract! platform, :id, :kind, :token, :name 
  end
end
json.contacts do
  json.array!(@user.contacts) do |contact|
    json.extract! contact, :id, :name
    json.items do 
      json.array!(contact.contact_items) do |item|
        json.extract! item, :id, :address, :name, :platform_id 
      end
    end
  end
end

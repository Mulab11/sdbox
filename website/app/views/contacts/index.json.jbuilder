json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :user_id
  json.url contact_url(contact, format: :json)
  json.items do
    json.array!(contact.contact_items) do |item|
      json.extract! item, :id, :address, :name, :platform_id 
    end
  end
end

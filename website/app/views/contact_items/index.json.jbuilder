json.array!(@contact_items) do |contact_item|
  json.extract! contact_item, :id, :address, :name, :platform_id, :contact_id
  json.url contact_item_url(contact_item, format: :json)
end

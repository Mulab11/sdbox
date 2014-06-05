json.extract! @contact, :id, :name, :user_id, :created_at, :updated_at
json.array!(@contact.contact_items) do |item|
  json.extract! item, :id, :address, :name, :platform_id 
end

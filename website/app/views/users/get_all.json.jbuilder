json.extract! @user, :id, :name
json.platforms do
  @user.platforms.each do |platform|
    json.set! platform.id do 
      json.extract! platform, :kind, :token, :name
    end
  end
end
json.contacts do
  @user.contacts.each do |contact|
    json.set! contact.id do
      json.extract! contact, :name
      json.items do
        contact.contact_items.each do |item|
          json.set! item.id do
            json.extract! item, :address, :name, :platform_id
          end
        end
      end
    end
  end
  /json.array!(@user.contacts) do |contact|
    json.extract! contact, :id, :name
    json.items do 
      json.array!(contact.contact_items) do |item|
        json.extract! item, :id, :address, :name, :platform_id 
      end
    end
  end/
end

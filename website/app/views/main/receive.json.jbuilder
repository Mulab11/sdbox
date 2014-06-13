json.array!(@messages) do |message|
  json.extract! message, :contact_item_id, :receive_time, :full_text
end

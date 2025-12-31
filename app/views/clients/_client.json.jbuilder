json.extract! client, :id, :name, :images, :created_at, :updated_at
json.url client_url(client, format: :json)
json.images do
  json.array!(client.images) do |image|
    json.id image.id
    json.url url_for(image)
  end
end

json.extract! service, :id, :name, :description, :images, :created_at, :updated_at
json.url service_url(service, format: :json)
json.images do
  json.array!(service.images) do |image|
    json.id image.id
    json.url url_for(image)
  end
end

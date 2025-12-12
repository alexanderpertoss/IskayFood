json.extract! order, :id, :total, :customer_name, :customer_shipping_address, :customer_phone, :customer_email, :status, :created_at, :updated_at
json.url order_url(order, format: :json)

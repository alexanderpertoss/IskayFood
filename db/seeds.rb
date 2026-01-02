# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
## Limpia la tabla antes de sembrar para evitar duplicados
# Limpiar datos previos para evitar duplicados al re-ejecutar el seed
puts "Cleaning database..."
Product.destroy_all
Service.destroy_all

puts "Creating products..."

Product.create!([
  {
    name: "Salteña",
    description: "The crown jewel of Bolivian street food. A savory pastry filled with a rich, juicy stew of meat, potatoes, and traditional spices, baked to golden perfection.",
    price: 4.50,
    weight: 0.180
  },
  {
    name: "Singani",
    description: "A unique and exclusive spirit distilled from Muscat of Alexandria grapes grown in the high-altitude valleys of the Andes. Crystal clear with intense floral aromas.",
    price: 35.00,
    weight: 0.750
  },
  {
    name: "Amazónica",
    description: "An exotic craft beer infused with Açaí berries from the Amazon rainforest. A refreshing, deep-purple brew with subtle fruity notes and a smooth finish.",
    price: 6.00,
    weight: 0.330
  },
  {
    name: "Empanadas",
    description: "Artisanal hand-folded pastries with a variety of fillings, including creamy cheese and seasoned vegetables, representing the diverse flavors of South America.",
    price: 3.50,
    weight: 0.120
  },
  {
    name: "Pralines",
    description: "Exquisite handmade chocolates using the finest Bolivian cacao, combined with caramelized nuts to create a sophisticated and crunchy indulgence.",
    price: 12.00,
    weight: 0.150
  }
])

puts "Creating services..."

Service.create!([
  {
    name: "Catering",
    description: "Bring the authentic flavors of Bolivia to your private events. We offer customized menus and professional service for weddings, corporate meetings, and celebrations."
  },
  {
    name: "Sandwich Shop",
    description: "Every sandwich is a culinary work of art. Our chefs work tirelessly to create unique recipes that combine tradition and innovation in every bite."
  },
  {
    name: "Bar",
    description: "A sophisticated space dedicated to South American spirits. Specializing in Singani-based cocktails and a curated selection of regional wines and craft beers."
  }
])
puts "Creating user..."
User.create! email_address: "example@email.com", password: "123456", password_confirmation: "123456"

puts "Seeds created successfully! Created #{Product.count} products, #{Service.count} services and the user."

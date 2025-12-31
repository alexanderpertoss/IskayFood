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
puts "Limpiando tabla de productos..."
Product.destroy_all

puts "Creando 9 productos de ejemplo..."

products_data = [
  {
    name: "Pique Macho",
    description: "Un plato tradicional cochabambino abundante con carne de res, salchicha, papas fritas, huevo duro, y rodajas de tomate y locoto.",
    price: 65.00
  },
  {
    name: "Majadito Batido",
    description: "Clásico del oriente boliviano. Arroz cocido y luego 'batido' con charque de res, huevo frito y plátano frito.",
    price: 55.00
  },
  {
    name: "Silpancho Clásico",
    description: "Fino filete de carne apanado sobre una cama de arroz y papas picadas, coronado con huevo frito.",
    price: 58.50
  },
  {
    name: "Fricasé Paceño",
    description: "Caldo picante de cerdo con mote, chuño, papa y un toque de ají amarillo. Ideal para levantar el ánimo.",
    price: 62.00
  },
  {
    name: "Pacumutu Oriental",
    description: "Brochetas de carne de res marinada, asadas a la parrilla, servidas con yuca y arroz.",
    price: 48.00
  },
  {
    name: "Cuñapé (Unidad)",
    description: "Pan de almidón y queso, horneado hasta dorar. Perfecto para el desayuno o la tarde.",
    price: 5.00
  },
  {
    name: "Salteña de Pollo",
    description: "Empanada jugosa rellena de un guiso dulce y picante con pollo, papa, huevo y aceitunas.",
    price: 12.00
  },
  {
    name: "Sopa de Maní",
    description: "Cremosa sopa a base de maní molido, acompañada de papas fritas y fideos.",
    price: 35.00
  },
  {
    name: "Pescado a la Plancha",
    description: "Filete de trucha o surubí a la plancha, servido con ensalada fresca y arroz blanco.",
    price: 75.00
  }
]

# Itera sobre los datos y crea los registros
products_data.each do |data|
  Product.create!(data)
end

puts "✅ Se han creado #{Product.count} productos exitosamente."


 User.create! email_address: "example@email.com", password: "123456", password_confirmation: "123456"

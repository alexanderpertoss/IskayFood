import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "mapContainer", 
    "addressInput", 
    "finalAddress", 
    "feeMessage", 
    "deliveryFeeInput"
  ]
  
  connect() {
    this.initializeMapSimulation()
  }

  // SIMULACIÓN: Inicializa el mapa y el listener de clic
  initializeMapSimulation() {
    console.log("Map Selector Controller: Map simulation ready. Click the map area to select an address.")
    
    // Simula el clic en el área del mapa
    this.mapContainerTarget.addEventListener('click', (e) => {
      // Generar coordenadas simuladas
      const fakeLat = 34.0522 + (Math.random() * 0.1 - 0.05)
      const fakeLng = -118.2437 + (Math.random() * 0.1 - 0.05)
      
      const simulatedAddress = `Simulated Address: Lat ${fakeLat.toFixed(4)}, Lng ${fakeLng.toFixed(4)}`
      this.handleLocationSelected(simulatedAddress, fakeLat, fakeLng)
    })
  }

  // ACCIÓN: Simula la geocodificación al buscar la dirección
  geocode(event) {
    event.preventDefault()
    const address = this.addressInputTarget.value
    
    if (address.length > 5) {
      console.log(`[GEOCODE] Simulating search for: ${address}`)
      // Simular un resultado exitoso de geocodificación
      const fakeLat = 34.0522 
      const fakeLng = -118.2437
      this.handleLocationSelected(address, fakeLat, fakeLng)
    }
  }

  // FUNCIÓN PRINCIPAL: Se llama cuando se selecciona una dirección (clic o búsqueda)
  handleLocationSelected(address, lat, lng) {
    // 1. Actualizar campos de formulario
    this.finalAddressTarget.value = address
    this.addressInputTarget.value = address

    // 2. Calcular el costo de envío
    const fee = this.calculateDeliveryFee(lat, lng) 
    this.deliveryFeeInputTarget.value = fee // Asigna la tarifa al campo oculto
    
    // 3. Notificar al usuario
    this.updateFeeDisplay(fee)
    
    // 4. Actualizar el total en el resumen (Llamada al servidor)
    this.updateCartTotals(fee)
  }

  // FUNCIÓN: Simula el cálculo de la tarifa de envío (aleatorio)
  calculateDeliveryFee(lat, lng) {
    // Generar un costo aleatorio entre 5.00 y 25.00
    return (Math.random() * 20 + 5).toFixed(2) 
  }

  // FUNCIÓN: Muestra la tarifa al usuario
  updateFeeDisplay(fee) {
    const formattedFee = new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: 'USD' 
    }).format(fee)
    
    this.feeMessageTarget.innerHTML = `Delivery address set. Delivery fee: <strong>${formattedFee}</strong>.`
    this.feeMessageTarget.classList.remove('alert-info')
    this.feeMessageTarget.classList.add('alert-success')
  }
  
  // FUNCIÓN: Llama al controlador de Rails para actualizar el total usando Turbo Stream
  updateCartTotals(fee) {
    // Llama al endpoint de Rails para que recalcule y devuelva el partial de totales
    const url = `/shop/update_delivery_fee?fee=${fee}`
    
    // Usamos fetch para simular una llamada Turbo Frame/Stream (o fetch + Turbo)
    fetch(url, {
      method: 'POST', // Usamos POST ya que estamos cambiando el estado de la sesión
      headers: {
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'text/vnd.turbo-stream.html', // Indica que esperamos un Turbo Stream
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    }).then(response => {
      if (response.ok) {
        // Turbo Frame/Stream es inyectado automáticamente en el DOM por el navegador
        // gracias al encabezado 'Accept' y la respuesta del servidor.
        console.log(`[AJAX Success] Total updated with fee: ${fee}`)
      } else {
        console.error('Failed to update delivery fee.')
      }
    })
  }
}
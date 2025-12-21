import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 1. Inicializar el mapa centrado en Bélgica (Bruselas)
    this.map = L.map('map').setView([50.8503, 4.3517], 13);

    // 2. Capa de diseño (OpenStreetMap)
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(this.map);

    // 3. Marcador vacío
    this.marker = L.marker([50.8503, 4.3517], { draggable: true }).addTo(this.map);

    // 4. Escuchar clics en el mapa
    this.map.on('click', (e) => this.updateLocation(e.latlng));
    this.marker.on('dragend', () => this.updateLocation(this.marker.getLatLng()));
  }

  async updateLocation(latlng) {
    this.marker.setLatLng(latlng);
    
    // Consultar Nominatim (OpenStreetMap) para obtener la dirección real
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.lat}&lon=${latlng.lng}&addressdetails=1`;
    
    try {
      const response = await fetch(url);
      const data = await response.json();
      
      if (data.address) {
        const postCode = data.address.postcode;
        const countryISO = data.address.country_code.toUpperCase(); // Da "BE", "ES", etc.
        const fullAddress = data.display_name;

        // Actualizar UI
        document.getElementById('address-display').innerText = fullAddress;
        document.getElementById('postal_code').value = postCode;
        document.getElementById('country_code').value = countryISO;

        // Si tenemos ambos datos, pedir el precio a Sendcloud
        if (postCode && countryISO) {
          this.fetchSendcloudPrice(postCode, countryISO);
        }
      }
    } catch (error) {
      console.error("Error fetching address:", error);
    }
  }

  fetchSendcloudPrice(postCode, countryISO) {
    // 1. Mostrar un estado de carga opcional
    const messageDiv = document.getElementById('fee_message');
    if (messageDiv) messageDiv.innerHTML = '<div class="text-muted">Calculating shipping...</div>';

    fetch(`/shop/update_delivery_fee?postal_code=${postCode}&country_code=${countryISO}`, {
      method: 'POST',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html', // <--- OBLIGATORIO PARA TURBO
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html)) // <--- ESTO FUERZA EL RENDERIZADO
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 1. Evitar errores si la librería no ha cargado aún (problema común en Turbo)
    if (typeof L === 'undefined' || typeof L.Control.Geocoder === 'undefined') {
      setTimeout(() => this.connect(), 100);
      return;
    }

    this.initializeMap();
  }

  initializeMap() {
    // Evitar duplicados si Stimulus reconecta
    if (this.map) { this.map.remove(); }

    // 2. Inicializar el mapa
    this.map = L.map('map').setView([50.8503, 4.3517], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors'
    }).addTo(this.map);

    this.marker = L.marker([50.8503, 4.3517], { draggable: true }).addTo(this.map);

    // 3. AGREGAR EL BUSCADOR (Geocoder)
    const geocoder = L.Control.Geocoder.nominatim({
      geocodingQueryParams: { countrycodes: 'be' } // Opcional: limitar a Bélgica
    });

    this.searchControl = L.Control.geocoder({
      query: "",
      placeholder: "Search address...",
      defaultMarkGeocode: false, 
      geocoder: geocoder
    })
    .on('markgeocode', (e) => {
      const latlng = e.geocode.center;
      this.map.setView(latlng, 16);
      this.updateLocation(latlng); // Dispara la lógica que ya tenías
    })
    .addTo(this.map);

    // 4. Escuchar eventos manuales
    this.map.on('click', (e) => this.updateLocation(e.latlng));
    this.marker.on('dragend', () => this.updateLocation(this.marker.getLatLng()));

    // 5. Fix para que el mapa cargue bien (no gris) la primera vez con Turbo
    setTimeout(() => {
      this.map.invalidateSize();
    }, 200);
  }

  async updateLocation(latlng) {
    // Bloquear botón de pago mientras validamos
    this.togglePayButton(false, "Validating...");

    this.marker.setLatLng(latlng);
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.lat}&lon=${latlng.lng}&addressdetails=1`;
    
    try {
      const response = await fetch(url);
      const data = await response.json();
      
      if (data.address) {
        const postCode = data.address.postcode || "";
        const countryISO = (data.address.country_code || "").toUpperCase();
        const fullAddress = data.display_name;

        document.getElementById('address-display').innerText = fullAddress;
        document.getElementById('postal_code').value = postCode;
        document.getElementById('country_code').value = countryISO;
        document.getElementById('shipping_address').value = fullAddress;

        if (postCode && countryISO) {
          this.fetchSendcloudPrice(postCode, countryISO);
        } else {
          this.togglePayButton(false, "Address without Postcode");
        }
      }
    } catch (error) {
      console.error("Error fetching address:", error);
      this.togglePayButton(false, "Map Error");
    }
  }

  fetchSendcloudPrice(postCode, countryISO) {
    const messageDiv = document.getElementById('fee_message');
    if (messageDiv) messageDiv.innerHTML = '<div class="text-muted small">Calculating shipping cost...</div>';

    fetch(`/shop/update_delivery_fee?postal_code=${postCode}&country_code=${countryISO}`, {
      method: 'POST',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
    .catch(() => this.togglePayButton(false, "Connection Error"));
  }

  // Función auxiliar para manejar el estado del botón Pay
  togglePayButton(enabled, text) {
    const btn = document.getElementById('pay-button');
    if (!btn) return;
    btn.disabled = !enabled;
    btn.innerText = text;
    if (enabled) {
        btn.classList.replace('btn-secondary', 'btn-primary');
    } else {
        btn.classList.replace('btn-primary', 'btn-secondary');
    }
  }

  disconnect() {
    if (this.map) {
      this.map.remove();
    }
  }
}
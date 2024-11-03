/**
 * Inicializa un mapa con Leaflet centrado en una latitud y longitud específicas,
 * añade una capa de mosaicos de OpenStreetMap, coloca un marcador en el centro,
 * y muestra un mensaje emergente.
 *
 * @function whereAreWe
 * @example
 * // Llama a esta función para inicializar el mapa y mostrar un marcador con un mensaje emergente
 * whereAreWe();
 */

function whereAreWe() {
    var map = L.map('map').setView([37.22388282132146, -3.6811505041233823], 13);

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);

    var marker = L.marker([37.22388282132146, -3.6811505041233823]).addTo(map)
        .bindPopup('Hello World!').openPopup();
}


window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "toggle") {
        var ui = document.getElementById('speedUI');
        ui.style.display = data.display ? 'block' : 'none';
    } else if (data.type === "update") {
        document.getElementById('currentSpeed').textContent = data.currentSpeed;
        document.getElementById('frontSpeed').textContent = data.frontSpeed;
        document.getElementById('licensePlateBox').textContent = data.licensePlate || 'Ingen'; 
    }
});

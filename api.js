// Archivo: api.js

async function fetchConRefresh(url, opciones = {}) {
  let token = localStorage.getItem('access_token');
  
  // Agregamos el token a las cabeceras
  opciones.headers = {
    ...opciones.headers,
    'Authorization': `Bearer ${token}`
  };

  let respuesta = await fetch(url, opciones);

  // Si el servidor dice "401 Unauthorized" (token vencido)
  if (respuesta.status === 401) {
    console.log("Token expirado. Intentando renovar en silencio...");
    const refreshToken = localStorage.getItem('refresh_token');
    
    // Vamos al puerto 9001 a pedir un token nuevo
    const refreshRes = await fetch('http://20.220.27.67/api/auth/refresh', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ refresh_token: refreshToken })
    });

    if (refreshRes.ok) {
      const data = await refreshRes.json();
      // Guardamos la nueva llave en el navegador
      localStorage.setItem('access_token', data.access_token);
      
      // Intentamos hacer la petición original de nuevo con la llave nueva
      opciones.headers['Authorization'] = `Bearer ${data.access_token}`;
      respuesta = await fetch(url, opciones);
    } else {
      // Si el refresh token también expiró, ahora sí cerramos la sesión
      localStorage.clear();
      window.location.href = 'login.html';
    }
  }

  return respuesta;
}
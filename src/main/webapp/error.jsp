<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .error-container { max-width: 500px; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; }
        h1 { color: #dc3545; margin-bottom: 20px; }
        .error-message { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 20px; border-radius: 4px; margin: 20px 0; }
        .btn { padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; margin-top: 20px; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-primary:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>❌ Error</h1>
        <div class="error-message">
            <%= request.getAttribute("errorMessage") != null ? 
                request.getAttribute("errorMessage") : "Ha ocurrido un error inesperado en el sistema" %>
        </div>
        <a href="vehiculos" class="btn btn-primary">🏠 Volver al Listado de Vehículos</a>
    </div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sistema Conexión - Gestión de Vehículos</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .welcome-container { text-align: center; background: white; padding: 50px; border-radius: 10px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); max-width: 500px; }
        h1 { color: #333; margin-bottom: 10px; }
        p { color: #666; margin-bottom: 30px; font-size: 16px; }
        .btn { display: inline-block; padding: 15px 30px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; font-size: 16px; transition: background 0.3s; }
        .btn:hover { background: #0056b3; }
        .features { text-align: left; margin: 30px 0; }
        .feature { margin: 15px 0; padding-left: 25px; position: relative; }
        .feature:before { content: "✓"; position: absolute; left: 0; color: #28a745; font-weight: bold; }
    </style>
</head>
<body>
    <div class="welcome-container">
        <h1>🚗 Sistema Conexión</h1>
        <p>Gestión Integral de Vehículos</p>
        
        <div class="features">
            <div class="feature">Gestión completa de vehículos</div>
            <div class="feature">Validaciones de negocio integradas</div>
            <div class="feature">Interfaz web moderna y responsive</div>
            <div class="feature">Reglas de negocio implementadas</div>
            <div class="feature">Base de datos MySQL integrada</div>
        </div>
        
        <a href="vehiculos" class="btn">Ingresar al Sistema</a>
    </div>
</body>
</html>
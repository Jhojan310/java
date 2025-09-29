<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.conexion.model.Vehiculo" %>
<%
    Vehiculo vehiculo = (Vehiculo) request.getAttribute("vehiculo");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirmar Eliminación</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 500px; margin: 50px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; }
        h1 { color: #333; margin-bottom: 20px; }
        .warning { color: #856404; background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; margin: 20px 0; border-radius: 4px; }
        .vehicle-info { text-align: left; background: #f8f9fa; padding: 20px; border-radius: 4px; margin: 20px 0; }
        .vehicle-info p { margin: 8px 0; }
        .btn { padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; margin: 0 10px; font-size: 14px; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-danger:hover { background-color: #c82333; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #545b62; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Confirmar Eliminación</h1>
        
        <div class="warning">
            <strong>¡Advertencia!</strong> Esta acción no se puede deshacer.
        </div>
        
        <p>¿Está seguro que desea eliminar el siguiente vehículo?</p>
        
        <div class="vehicle-info">
            <p><strong>Placa:</strong> <%= vehiculo.getPlaca() %></p>
            <p><strong>Marca:</strong> <%= vehiculo.getMarca() %></p>
            <p><strong>Modelo:</strong> <%= vehiculo.getModelo() %></p>
            <p><strong>Color:</strong> <%= vehiculo.getColor() %></p>
            <p><strong>Año:</strong> <%= vehiculo.getAño() %></p>
            <p><strong>Propietario:</strong> <%= vehiculo.getPropietario() %></p>
        </div>
        
        <div>
            <form method="post" action="vehiculos" style="display: inline;">
                <input type="hidden" name="action" value="confirmDelete">
                <input type="hidden" name="id" value="<%= vehiculo.getId() %>">
                <button type="submit" class="btn btn-danger">Eliminar Vehículo</button>
            </form>
            
            <a href="vehiculos" class="btn btn-secondary">Cancelar</a>
        </div>
    </div>
</body>
</html>
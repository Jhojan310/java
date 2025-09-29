<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.conexion.model.Vehiculo" %>
<%
    Vehiculo vehiculo = (Vehiculo) request.getAttribute("vehiculo");
    String action = (String) request.getAttribute("action");
    boolean isEdit = "update".equals(action);
    String title = isEdit ? "Editar Vehículo" : "Nuevo Vehículo";
    
    // Si es creación y no hay vehículo, crear uno vacío
    if (vehiculo == null) {
        vehiculo = new Vehiculo();
    }
    
    // Obtener año actual para validaciones
    java.util.Calendar cal = java.util.Calendar.getInstance();
    int añoActual = cal.get(java.util.Calendar.YEAR);
    int añoMinimo = añoActual - 20;
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .form-container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #333; text-align: center; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
        input, select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        input:focus, select:focus { outline: none; border-color: #007bff; box-shadow: 0 0 5px rgba(0,123,255,0.3); }
        .btn { padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; margin-right: 10px; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-primary:hover { background-color: #0056b3; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #545b62; }
        .error { color: #dc3545; margin-bottom: 20px; padding: 15px; background-color: #f8d7da; border: 1px solid #f5c6cb; border-radius: 4px; }
        .form-actions { text-align: center; margin-top: 30px; }
        .info-text { font-size: 12px; color: #666; margin-top: 5px; }
    </style>
</head>
<body>
    <div class="form-container">
        <h1><%= title %></h1>
        
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="error">
                <strong>Error:</strong> <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>
        
        <form method="post" action="vehiculos">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= vehiculo.getId() %>">
            <% } %>
            
            <div class="form-group">
                <label for="placa">Placa *</label>
                <input type="text" id="placa" name="placa" value="<%= vehiculo.getPlaca() != null ? vehiculo.getPlaca() : "" %>" 
                       required maxlength="20" placeholder="Ej: ABC123">
                <div class="info-text">Mínimo 3 caracteres. Debe ser única en el sistema.</div>
            </div>
            
            <div class="form-group">
                <label for="marca">Marca *</label>
                <input type="text" id="marca" name="marca" value="<%= vehiculo.getMarca() != null ? vehiculo.getMarca() : "" %>" 
                       required maxlength="30" placeholder="Ej: Toyota">
                <div class="info-text">Mínimo 3 caracteres.</div>
            </div>
            
            <div class="form-group">
                <label for="modelo">Modelo *</label>
                <input type="text" id="modelo" name="modelo" value="<%= vehiculo.getModelo() != null ? vehiculo.getModelo() : "" %>" 
                       required maxlength="30" placeholder="Ej: Corolla">
                <div class="info-text">Mínimo 3 caracteres.</div>
            </div>
            
            <div class="form-group">
                <label for="color">Color *</label>
                <select id="color" name="color" required>
                    <option value="">Seleccione un color</option>
                    <option value="Rojo" <%= "Rojo".equals(vehiculo.getColor()) ? "selected" : "" %>>Rojo</option>
                    <option value="Blanco" <%= "Blanco".equals(vehiculo.getColor()) ? "selected" : "" %>>Blanco</option>
                    <option value="Negro" <%= "Negro".equals(vehiculo.getColor()) ? "selected" : "" %>>Negro</option>
                    <option value="Azul" <%= "Azul".equals(vehiculo.getColor()) ? "selected" : "" %>>Azul</option>
                    <option value="Gris" <%= "Gris".equals(vehiculo.getColor()) ? "selected" : "" %>>Gris</option>
                    <option value="Verde" <%= "Verde".equals(vehiculo.getColor()) ? "selected" : "" %>>Verde</option>
                    <option value="Amarillo" <%= "Amarillo".equals(vehiculo.getColor()) ? "selected" : "" %>>Amarillo</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="año">Año *</label>
                <input type="number" id="año" name="año" 
                       value="<%= vehiculo.getAño() != 0 ? vehiculo.getAño() : "" %>" 
                       min="<%= añoMinimo %>" max="<%= añoActual %>" 
                       required placeholder="Ej: 2023">
                <div class="info-text">Rango permitido: <%= añoMinimo %> - <%= añoActual %> (máximo 20 años de antigüedad)</div>
            </div>
            
            <div class="form-group">
                <label for="propietario">Propietario *</label>
                <input type="text" id="propietario" name="propietario" 
                       value="<%= vehiculo.getPropietario() != null ? vehiculo.getPropietario() : "" %>" 
                       required maxlength="50" placeholder="Ej: Juan Pérez">
                <div class="info-text">Mínimo 5 caracteres. No puede ser "Administrador" para eliminación.</div>
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    <%= isEdit ? "Actualizar Vehículo" : "Crear Vehículo" %>
                </button>
                <a href="vehiculos" class="btn btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</body>
</html>
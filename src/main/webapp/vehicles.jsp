<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mycompany.conexion.model.Vehiculo" %>
<%@ page import="java.util.List" %>
<%
    List<Vehiculo> vehiculos = (List<Vehiculo>) request.getAttribute("vehiculos");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Vehículos - Sistema Conexión</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 2px solid #007bff; }
        h1 { color: #333; margin: 0; }
        .btn { padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-primary:hover { background-color: #0056b3; }
        .btn-warning { background-color: #ffc107; color: black; }
        .btn-warning:hover { background-color: #e0a800; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-danger:hover { background-color: #c82333; }
        .success { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        .error { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; padding: 15px; margin-bottom: 20px; border-radius: 4px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { border: 1px solid #ddd; padding: 15px; text-align: left; }
        th { background-color: #007bff; color: white; font-weight: bold; }
        tr:nth-child(even) { background-color: #f8f9fa; }
        tr:hover { background-color: #e9ecef; }
        .actions { white-space: nowrap; }
        .actions a { margin-right: 8px; }
        .empty-message { text-align: center; padding: 40px; color: #666; font-size: 18px; background: white; border-radius: 4px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚗 Gestión de Vehículos - Sistema Conexión</h1>
            <a href="vehiculos?action=create" class="btn btn-primary">➕ Nuevo Vehículo</a>
        </div>
        
        <% if (successMessage != null) { %>
            <div class="success">
                ✅ <%= successMessage %>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="error">
                ❌ <%= errorMessage %>
            </div>
        <% } %>
        
        <% if (vehiculos != null && !vehiculos.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Placa</th>
                        <th>Marca</th>
                        <th>Modelo</th>
                        <th>Color</th>
                        <th>Año</th>
                        <th>Propietario</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Vehiculo vehiculo : vehiculos) { %>
                        <tr>
                            <td><%= vehiculo.getId() %></td>
                            <td><strong><%= vehiculo.getPlaca() %></strong></td>
                            <td><%= vehiculo.getMarca() %></td>
                            <td><%= vehiculo.getModelo() %></td>
                            <td>
                                <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: 
                                    <% switch(vehiculo.getColor()) { 
                                        case "Rojo": out.print("#dc3545"); break;
                                        case "Blanco": out.print("#f8f9fa"); break;
                                        case "Negro": out.print("#212529"); break;
                                        case "Azul": out.print("#007bff"); break;
                                        case "Gris": out.print("#6c757d"); break;
                                        case "Verde": out.print("#28a745"); break;
                                        case "Amarillo": out.print("#ffc107"); break;
                                        default: out.print("#6c757d"); break;
                                    } %>; border: 1px solid #ccc; margin-right: 8px;"></span>
                                <%= vehiculo.getColor() %>
                            </td>
                            <td><%= vehiculo.getAño() %></td>
                            <td><%= vehiculo.getPropietario() %></td>
                            <td class="actions">
                                <a href="vehiculos?action=edit&id=<%= vehiculo.getId() %>" class="btn btn-warning">✏️ Editar</a>
                                <a href="vehiculos?action=delete&id=<%= vehiculo.getId() %>" class="btn btn-danger">🗑️ Eliminar</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-message">
                <p>No hay vehículos registrados en el sistema.</p>
                <a href="vehiculos?action=create" class="btn btn-primary">Registrar Primer Vehículo</a>
            </div>
        <% } %>
    </div>
</body>
</html>
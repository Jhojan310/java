<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Verificar si viene de un formulario o es primera carga
    boolean esPostback = "POST".equals(request.getMethod());
    boolean mostrarFormulario = true;
    
    // Si no es postback, podría ser una redirección
    if (!esPostback && request.getParameter("redirect") != null) {
        mostrarFormulario = true;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🏢 Sistema de Gestión de Vehículos - Garaje</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header .subtitle {
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .content {
            padding: 30px;
        }
        
        .message {
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            font-weight: bold;
        }
        
        .success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .form-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin: 25px 0;
            border-left: 5px solid #3498db;
        }
        
        .form-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        input, select {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
        }
        
        .btn {
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        }
        
        .btn-small {
            padding: 8px 15px;
            font-size: 14px;
        }
        
        .table-container {
            overflow-x: auto;
            margin: 30px 0;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #34495e;
            color: white;
            font-weight: 600;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            display: block;
        }
        
        .info-section {
            background: #e8f4fc;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
        }
        
        .rules-list {
            list-style: none;
            padding: 0;
        }
        
        .rules-list li {
            padding: 8px 0;
            border-bottom: 1px solid #ddd;
        }
        
        .rules-list li:before {
            content: "✅ ";
            margin-right: 10px;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .content {
                padding: 20px;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🏢 Sistema de Gestión de Vehículos</h1>
            <div class="subtitle">Garaje - Control y Administración</div>
        </div>
        
        <div class="content">
            <%
            Connection conexion = null;
            String mensaje = "";
            String tipoMensaje = "";
            int totalVehiculos = 0;
            int totalFerraris = 0;
            
            // Procesar formularios
            if (esPostback) {
                String action = request.getParameter("action");
                
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conexion = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/garaje", 
                        "root", 
                        "JHOJAN3102634360"
                    );
                    
                    if ("agregar".equals(action)) {
                        String placa = request.getParameter("placa");
                        String marca = request.getParameter("marca");
                        String modelo = request.getParameter("modelo");
                        String color = request.getParameter("color");
                        String propietario = request.getParameter("propietario");
                        
                        // Validaciones básicas
                        if (placa == null || placa.trim().isEmpty() || 
                            marca == null || marca.trim().isEmpty() || 
                            modelo == null || modelo.trim().isEmpty() || 
                            propietario == null || propietario.trim().isEmpty()) {
                            
                            mensaje = "❌ Todos los campos son obligatorios";
                            tipoMensaje = "error";
                        } else if (placa.trim().length() < 3) {
                            mensaje = "❌ La placa debe tener al menos 3 caracteres";
                            tipoMensaje = "error";
                        } else if (marca.trim().length() < 3) {
                            mensaje = "❌ La marca debe tener al menos 3 caracteres";
                            tipoMensaje = "error";
                        } else if (modelo.trim().length() < 3) {
                            mensaje = "❌ El modelo debe tener al menos 3 caracteres";
                            tipoMensaje = "error";
                        } else if (propietario.trim().length() < 5) {
                            mensaje = "❌ El propietario debe tener al menos 5 caracteres";
                            tipoMensaje = "error";
                        } else {
                            // Verificar si la placa ya existe
                            String sqlCheck = "SELECT COUNT(*) FROM vehiculos WHERE placa = ?";
                            PreparedStatement psCheck = conexion.prepareStatement(sqlCheck);
                            psCheck.setString(1, placa.trim().toUpperCase());
                            ResultSet rs = psCheck.executeQuery();
                            rs.next();
                            int existe = rs.getInt(1);
                            rs.close();
                            psCheck.close();
                            
                            if (existe > 0) {
                                mensaje = "❌ Error: La placa " + placa + " ya está registrada";
                                tipoMensaje = "error";
                            } else {
                                // Insertar nuevo vehículo
                                String sql = "INSERT INTO vehiculos (placa, marca, modelo, color, propietario) VALUES (?, ?, ?, ?, ?)";
                                PreparedStatement ps = conexion.prepareStatement(sql);
                                ps.setString(1, placa.trim().toUpperCase());
                                ps.setString(2, marca.trim());
                                ps.setString(3, modelo.trim());
                                ps.setString(4, color);
                                ps.setString(5, propietario.trim());
                                ps.executeUpdate();
                                ps.close();
                                
                                mensaje = "✅ Vehículo agregado exitosamente";
                                tipoMensaje = "success";
                                
                                // Notificación especial para Ferrari
                                if ("Ferrari".equalsIgnoreCase(marca)) {
                                    System.out.println("🚨 NOTIFICACIÓN: Se ha agregado un Ferrari - Placa: " + placa);
                                }
                            }
                        }
                    }
                    else if ("eliminar".equals(action)) {
                        String idStr = request.getParameter("id");
                        if (idStr != null && !idStr.trim().isEmpty()) {
                            int id = Integer.parseInt(idStr);
                            
                            // Verificar propietario antes de eliminar
                            String sqlCheck = "SELECT propietario FROM vehiculos WHERE id = ?";
                            PreparedStatement psCheck = conexion.prepareStatement(sqlCheck);
                            psCheck.setInt(1, id);
                            ResultSet rs = psCheck.executeQuery();
                            
                            if (rs.next()) {
                                String propietario = rs.getString("propietario");
                                if ("Administrador".equalsIgnoreCase(propietario)) {
                                    mensaje = "❌ No se puede eliminar un vehículo del propietario 'Administrador'";
                                    tipoMensaje = "error";
                                } else {
                                    String sql = "DELETE FROM vehiculos WHERE id = ?";
                                    PreparedStatement ps = conexion.prepareStatement(sql);
                                    ps.setInt(1, id);
                                    ps.executeUpdate();
                                    ps.close();
                                    
                                    mensaje = "✅ Vehículo eliminado exitosamente";
                                    tipoMensaje = "success";
                                }
                            }
                            rs.close();
                            psCheck.close();
                        }
                    }
                    
                } catch (ClassNotFoundException e) {
                    mensaje = "❌ Error: Driver de MySQL no encontrado: " + e.getMessage();
                    tipoMensaje = "error";
                } catch (SQLException e) {
                    mensaje = "❌ Error de base de datos: " + e.getMessage();
                    tipoMensaje = "error";
                } catch (NumberFormatException e) {
                    mensaje = "❌ Error: ID inválido";
                    tipoMensaje = "error";
                } finally {
                    if (conexion != null) {
                        try { conexion.close(); } catch (SQLException e) {}
                    }
                }
            }
            %>

            <% if (!mensaje.isEmpty()) { %>
                <div class="message <%= tipoMensaje %>"><%= mensaje %></div>
            <% } %>

            <!-- Estadísticas -->
            <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conexion = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/garaje", 
                    "root", 
                    "JHOJAN3102634360"
                );
                
                // Obtener estadísticas
                Statement stmtStats = conexion.createStatement();
                ResultSet rsStats = stmtStats.executeQuery("SELECT COUNT(*) as total, SUM(CASE WHEN UPPER(marca) = 'FERRARI' THEN 1 ELSE 0 END) as ferraris FROM vehiculos");
                if (rsStats.next()) {
                    totalVehiculos = rsStats.getInt("total");
                    totalFerraris = rsStats.getInt("ferraris");
                }
                rsStats.close();
                stmtStats.close();
                
            } catch (Exception e) {
                // Ignorar errores de estadísticas
            } finally {
                if (conexion != null) {
                    try { conexion.close(); } catch (SQLException e) {}
                }
            }
            %>
            
            <div class="stats">
                <div class="stat-card">
                    <span class="stat-number"><%= totalVehiculos %></span>
                    <span>Vehículos Registrados</span>
                </div>
                <div class="stat-card">
                    <span class="stat-number"><%= totalFerraris %></span>
                    <span>Vehículos Ferrari</span>
                </div>
            </div>

            <!-- Formulario para agregar vehículo -->
            <div class="form-section">
                <h2>➕ Agregar Nuevo Vehículo</h2>
                <form method="post" action="conexion.jsp">
                    <input type="hidden" name="action" value="agregar">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="placa">Placa:</label>
                            <input type="text" id="placa" name="placa" required maxlength="20" 
                                   placeholder="Ej: ABC123" pattern="[A-Z0-9]{3,20}" 
                                   title="Solo letras mayúsculas y números (mín. 3 caracteres)">
                        </div>
                        
                        <div class="form-group">
                            <label for="marca">Marca:</label>
                            <input type="text" id="marca" name="marca" required maxlength="30" 
                                   placeholder="Ej: Toyota, Honda, Ferrari" 
                                   title="Mínimo 3 caracteres">
                        </div>
                        
                        <div class="form-group">
                            <label for="modelo">Modelo:</label>
                            <input type="text" id="modelo" name="modelo" required maxlength="30" 
                                   placeholder="Ej: Corolla, Civic, F8" 
                                   title="Mínimo 3 caracteres">
                        </div>
                        
                        <div class="form-group">
                            <label for="color">Color:</label>
                            <select id="color" name="color" required>
                                <option value="">Seleccione color</option>
                                <option value="Rojo">Rojo</option>
                                <option value="Blanco">Blanco</option>
                                <option value="Negro">Negro</option>
                                <option value="Azul">Azul</option>
                                <option value="Gris">Gris</option>
                                <option value="Verde">Verde</option>
                                <option value="Amarillo">Amarillo</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="propietario">Propietario:</label>
                            <input type="text" id="propietario" name="propietario" required maxlength="50" 
                                   placeholder="Nombre completo del propietario" 
                                   title="Mínimo 5 caracteres">
                        </div>
                    </div>
                    
                    <button type="submit" class="btn">🚗 Agregar Vehículo</button>
                </form>
            </div>

            <!-- Lista de vehículos -->
            <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conexion = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/garaje", 
                    "root", 
                    "JHOJAN3102634360"
                );
                
                Statement stmt = conexion.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM vehiculos ORDER BY id DESC");
            %>
            
            <div class="form-section">
                <h2>📋 Vehículos Registrados</h2>
                
                <% if (!rs.isBeforeFirst()) { %>
                    <div style="text-align: center; padding: 40px; color: #666;">
                        <h3>No hay vehículos registrados aún</h3>
                        <p>Comienza agregando el primer vehículo usando el formulario superior.</p>
                    </div>
                <% } else { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Placa</th>
                                    <th>Marca</th>
                                    <th>Modelo</th>
                                    <th>Color</th>
                                    <th>Propietario</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% while(rs.next()) { %>
                                <tr>
                                    <td><strong>#<%= rs.getInt("id") %></strong></td>
                                    <td><span style="font-weight: bold; color: #2c3e50;"><%= rs.getString("placa") %></span></td>
                                    <td>
                                        <%= rs.getString("marca") %>
                                        <% if ("Ferrari".equalsIgnoreCase(rs.getString("marca"))) { %>
                                            🏎️
                                        <% } %>
                                    </td>
                                    <td><%= rs.getString("modelo") %></td>
                                    <td>
                                        <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; 
                                              background: <%= getColorCode(rs.getString("color")) %>; margin-right: 5px;"></span>
                                        <%= rs.getString("color") %>
                                    </td>
                                    <td><%= rs.getString("propietario") %></td>
                                    <td>
                                        <form method="post" action="conexion.jsp" style="display: inline;">
                                            <input type="hidden" name="action" value="eliminar">
                                            <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                            <button type="submit" class="btn btn-danger btn-small" 
                                                    onclick="return confirm('¿Está seguro de eliminar el vehículo con placa <%= rs.getString("placa") %>?')">
                                                🗑️ Eliminar
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } 
                
                rs.close();
                stmt.close();
                
            } catch (ClassNotFoundException e) { %>
                <div class="message error">
                    <h3>❌ Error de Configuración</h3>
                    <p>Driver de MySQL no encontrado. Asegúrate de tener el connector J de MySQL en el classpath.</p>
                </div>
            <% } catch (SQLException e) { %>
                <div class="message error">
                    <h3>❌ Error de Conexión a la Base de Datos</h3>
                    <p><strong>Mensaje:</strong> <%= e.getMessage() %></p>
                    <div style="margin-top: 15px;">
                        <h4>📋 Pasos para solucionar:</h4>
                        <ol>
                            <li>Verifica que MySQL esté ejecutándose</li>
                            <li>Crea la base de datos: <code>CREATE DATABASE garaje;</code></li>
                            <li>Ejecuta el script SQL proporcionado</li>
                            <li>Verifica usuario y contraseña de MySQL</li>
                        </ol>
                    </div>
                </div>
            <% } finally {
                if (conexion != null) {
                    try { conexion.close(); } catch (SQLException e) {}
                }
            }
            %>

            <!-- Información del sistema -->
            <div class="info-section">
                <h3>ℹ️ Información del Sistema</h3>
                <div class="form-grid">
                    <div>
                        <h4>Configuración de Base de Datos</h4>
                        <ul>
                            <li><strong>Base de datos:</strong> garaje</li>
                            <li><strong>Tabla:</strong> vehiculos</li>
                            <li><strong>Usuario MySQL:</strong> root</li>
                            <li><strong>Servidor:</strong> localhost:3306</li>
                        </ul>
                    </div>
                    <div>
                        <h4>Reglas de Negocio Implementadas</h4>
                        <ul class="rules-list">
                            <li>No permite placas duplicadas</li>
                            <li>No permite eliminar vehículos del "Administrador"</li>
                            <li>Notificación especial para vehículos Ferrari</li>
                            <li>Validación de campos obligatorios</li>
                            <li>Mínimo 3 caracteres para placa, marca y modelo</li>
                            <li>Mínimo 5 caracteres para propietario</li>
                            <li>Colores predefinidos</li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>

</body>
</html>

<%!
    // Método auxiliar para obtener código de color
    private String getColorCode(String color) {
        if (color == null) return "#ccc";
        switch (color.toLowerCase()) {
            case "rojo": return "#e74c3c";
            case "blanco": return "#ecf0f1";
            case "negro": return "#2c3e50";
            case "azul": return "#3498db";
            case "gris": return "#95a5a6";
            case "verde": return "#2ecc71";
            case "amarillo": return "#f1c40f";
            default: return "#ccc";
        }
    }
%>
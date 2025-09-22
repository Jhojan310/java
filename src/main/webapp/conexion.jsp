<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Prueba de Conexión</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .success { color: green; padding: 10px; background: #f0fff0; border: 1px solid green; }
        .error { color: red; padding: 10px; background: #fff0f0; border: 1px solid red; }
        table { border-collapse: collapse; margin-top: 20px; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Test de Conexión a Base de Datos</h1>
    
    <%
    Connection conexion = null;
    try {
        String url = "jdbc:mysql://localhost:3306/conexion_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        String usuario = "root";
        String password = "JHOJAN3102634360";
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        conexion = DriverManager.getConnection(url, usuario, password);
        
        if(conexion != null && !conexion.isClosed()) {
    %>
            <div class="success">✅ Conexión exitosa a la base de datos!</div>
            
            <h2>Vehículos registrados:</h2>
            <%
            Statement stmt = conexion.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM vehicles");
            int contador = 0;
            %>
            
            <table>
                <tr>
                    <th>ID</th>
                    <th>Marca</th>
                    <th>Modelo</th>
                    <th>Año</th>
                    <th>Propietario</th>
                </tr>
                <% while(rs.next()) { 
                    contador++;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("brand") %></td>
                    <td><%= rs.getString("model") %></td>
                    <td><%= rs.getInt("year") %></td>
                    <td><%= rs.getString("owner") %></td>
                </tr>
                <% } %>
            </table>
            
            <p><strong>Total de vehículos: <%= contador %></strong></p>
            
            <%
            rs.close();
            stmt.close();
        }
        
    } catch (ClassNotFoundException e) {
    %>
        <div class="error">❌ Error: Driver de MySQL no encontrado.</div>
    <%
    } catch (SQLException e) {
    %>
        <div class="error">❌ Error de SQL: <%= e.getMessage() %></div>
    <%
    } finally {
        if (conexion != null) {
            try { conexion.close(); } catch (SQLException e) {}
        }
    }
    %>
    
    <br>
    <a href="vehicles">Volver al sistema de vehículos</a>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lista de Vehículos</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        form { margin-bottom: 20px; padding: 15px; border: 1px solid #ccc; }
        input[type="text"], input[type="number"] { margin-bottom: 10px; padding: 5px; }
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h1>Sistema de Gestión de Vehículos</h1>
    
    <%
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    %>
        <div class="<%= messageType %>"><%= message %></div>
    <%
    }
    %>

    <h2>Agregar Vehículo</h2>
    <form action="vehicles" method="post">
        Marca: <input type="text" name="brand" required/><br/>
        Modelo: <input type="text" name="model" required/><br/>
        Año: <input type="number" name="year" required min="1900" max="2030"/><br/>
        Propietario: <input type="text" name="owner" required/><br/>
        <input type="submit" value="Agregar Vehículo" />
    </form>

    <h2>Lista de Vehículos Registrados</h2>
    <c:if test="${empty vehicles}">
        <p>No hay vehículos registrados.</p>
    </c:if>
    
    <c:if test="${not empty vehicles}">
        <table>
            <tr>
                <th>ID</th>
                <th>Marca</th>
                <th>Modelo</th>
                <th>Año</th>
                <th>Propietario</th>
            </tr>
            <c:forEach var="vehicle" items="${vehicles}">
                <tr>
                    <td>${vehicle.id}</td>
                    <td>${vehicle.brand}</td>
                    <td>${vehicle.model}</td>
                    <td>${vehicle.year}</td>
                    <td>${vehicle.owner}</td>
                </tr>
            </c:forEach>
        </table>
    </c:if>
    
    <br>
    <a href="conexion.jsp">Probar conexión directa</a>
</body>
</html>
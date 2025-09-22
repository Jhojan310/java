package com.mycompany.conexion;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/vehicles")
public class VehicleServlet extends HttpServlet {

    private DataSource dataSource;

    @Override
    public void init() throws ServletException {
        try {
            Context initContext = new InitialContext();
            dataSource = (DataSource) initContext.lookup("java:comp/env/jdbc/garageDB");
        } catch (Exception e) {
            throw new ServletException("Error al inicializar el DataSource", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Vehicle> vehicles = new ArrayList<>();

        try (Connection conn = dataSource.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM vehicles");
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                vehicles.add(new Vehicle(
                    rs.getInt("id"), 
                    rs.getString("brand"), 
                    rs.getString("model"), 
                    rs.getInt("year"), 
                    rs.getString("owner")
                ));
            }
        } catch (Exception e) {
            throw new ServletException("Error al obtener vehículos", e);
        }

        request.setAttribute("vehicles", vehicles);
        request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String brand = request.getParameter("brand");
        String model = request.getParameter("model");
        String yearStr = request.getParameter("year");
        String owner = request.getParameter("owner");

        try {
            int year = Integer.parseInt(yearStr);
            
            try (Connection conn = dataSource.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("INSERT INTO vehicles (brand, model, year, owner) VALUES (?, ?, ?, ?)")) {
                
                stmt.setString(1, brand);
                stmt.setString(2, model);
                stmt.setInt(3, year);
                stmt.setString(4, owner);
                stmt.executeUpdate();
                
                request.getSession().setAttribute("message", "Vehículo agregado exitosamente!");
                request.getSession().setAttribute("messageType", "success");
                
            } catch (Exception e) {
                request.getSession().setAttribute("message", "Error al agregar vehículo: " + e.getMessage());
                request.getSession().setAttribute("messageType", "error");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "El año debe ser un número válido");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect("vehicles");
    }
}
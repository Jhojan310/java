package com.mycompany.conexion.controller;

import com.mycompany.conexion.model.Vehiculo;
import com.mycompany.conexion.facade.VehiculoFacade;
import com.mycompany.conexion.exceptions.BusinessException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Controlador web para la gestión de vehículos.
 * Recibe peticiones HTTP y las traduce en operaciones CRUD.
 * Debe mostrar mensajes claros en error de negocio.
 */
@WebServlet("/vehiculos")
public class VehiculoServlet extends HttpServlet {
    private VehiculoFacade vehiculoFacade;

    @Override
    public void init() throws ServletException {
        super.init();
        vehiculoFacade = new VehiculoFacade();
    }

    /**
     * Maneja peticiones GET para listar y buscar vehículos
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                // Mostrar formulario de creación
                mostrarFormularioCreacion(request, response);
            } else if ("edit".equals(action)) {
                // Mostrar formulario de edición
                mostrarFormularioEdicion(request, response);
            } else if ("delete".equals(action)) {
                // Mostrar confirmación de eliminación
                mostrarConfirmacionEliminacion(request, response);
            } else {
                // Listar todos los vehículos
                listarVehiculos(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, "Error al procesar la solicitud: " + e.getMessage());
        }
    }

    /**
     * Maneja peticiones POST para crear, actualizar y eliminar vehículos
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                crearVehiculo(request, response);
            } else if ("update".equals(action)) {
                actualizarVehiculo(request, response);
            } else if ("confirmDelete".equals(action)) {
                eliminarVehiculo(request, response);
            } else {
                listarVehiculos(request, response);
            }
        } catch (Exception e) {
            manejarError(request, response, "Error al procesar la solicitud: " + e.getMessage());
        }
    }

    /**
     * Lista todos los vehículos
     */
    private void listarVehiculos(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        List<Vehiculo> vehiculos = vehiculoFacade.listar();
        request.setAttribute("vehiculos", vehiculos);
        
        // Verificar si hay mensaje de éxito en los parámetros
        String message = request.getParameter("message");
        if (message != null) {
            request.setAttribute("successMessage", message);
        }
        
        request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
    }

    /**
     * Muestra formulario de creación
     */
    private void mostrarFormularioCreacion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("action", "create");
        request.getRequestDispatcher("/vehiculo-form.jsp").forward(request, response);
    }

    /**
     * Muestra formulario de edición
     */
    private void mostrarFormularioEdicion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Vehiculo vehiculo = vehiculoFacade.buscarPorId(id);
        
        if (vehiculo != null) {
            request.setAttribute("vehiculo", vehiculo);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/vehiculo-form.jsp").forward(request, response);
        } else {
            manejarError(request, response, "Vehículo no encontrado");
        }
    }

    /**
     * Muestra confirmación de eliminación
     */
    private void mostrarConfirmacionEliminacion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        Vehiculo vehiculo = vehiculoFacade.buscarPorId(id);
        
        if (vehiculo != null) {
            request.setAttribute("vehiculo", vehiculo);
            request.getRequestDispatcher("/confirmar-eliminacion.jsp").forward(request, response);
        } else {
            manejarError(request, response, "Vehículo no encontrado");
        }
    }

    /**
     * Crea un nuevo vehículo
     */
    private void crearVehiculo(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Vehiculo vehiculo = extraerVehiculoDeRequest(request);
            vehiculoFacade.agregar(vehiculo);
            response.sendRedirect("vehiculos?message=Vehículo creado exitosamente");
        } catch (BusinessException e) {
            request.setAttribute("vehiculo", extraerVehiculoDeRequest(request));
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("action", "create");
            request.getRequestDispatcher("/vehiculo-form.jsp").forward(request, response);
        } catch (SQLException e) {
            manejarError(request, response, "Error de base de datos: " + e.getMessage());
        }
    }

    /**
     * Actualiza un vehículo existente
     */
    private void actualizarVehiculo(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Vehiculo vehiculo = extraerVehiculoDeRequest(request);
            vehiculo.setId(Integer.parseInt(request.getParameter("id")));
            vehiculoFacade.actualizar(vehiculo);
            response.sendRedirect("vehiculos?message=Vehículo actualizado exitosamente");
        } catch (BusinessException e) {
            request.setAttribute("vehiculo", extraerVehiculoDeRequest(request));
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/vehiculo-form.jsp").forward(request, response);
        } catch (SQLException e) {
            manejarError(request, response, "Error de base de datos: " + e.getMessage());
        }
    }

    /**
     * Elimina un vehículo
     */
    private void eliminarVehiculo(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            vehiculoFacade.eliminar(id);
            response.sendRedirect("vehiculos?message=Vehículo eliminado exitosamente");
        } catch (BusinessException e) {
            manejarError(request, response, e.getMessage());
        } catch (SQLException e) {
            manejarError(request, response, "Error de base de datos: " + e.getMessage());
        }
    }

    /**
     * Extrae los datos del vehículo del request
     */
    private Vehiculo extraerVehiculoDeRequest(HttpServletRequest request) {
        Vehiculo vehiculo = new Vehiculo();
        vehiculo.setPlaca(request.getParameter("placa"));
        vehiculo.setMarca(request.getParameter("marca"));
        vehiculo.setModelo(request.getParameter("modelo"));
        vehiculo.setColor(request.getParameter("color"));
        
        try {
            vehiculo.setAño(Integer.parseInt(request.getParameter("año")));
        } catch (NumberFormatException e) {
            vehiculo.setAño(0); // Será validado después
        }
        
        vehiculo.setPropietario(request.getParameter("propietario"));
        return vehiculo;
    }

    /**
     * Maneja errores y muestra mensajes al usuario
     */
    private void manejarError(HttpServletRequest request, HttpServletResponse response, String mensaje) 
            throws ServletException, IOException {
        request.setAttribute("errorMessage", mensaje);
        try {
            listarVehiculos(request, response);
        } catch (Exception e) {
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
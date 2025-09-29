package com.mycompany.conexion.facade;

import com.mycompany.conexion.model.Vehiculo;
import com.mycompany.conexion.persistence.VehiculoDAO;
import com.mycompany.conexion.exceptions.BusinessException;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Arrays;
import java.util.List;

/**
 * Fachada para operaciones sobre vehículos.
 * Versión con conexión directa (sin JNDI)
 */
public class VehiculoFacade {
    
    // Datos de conexión directa - MODIFICA ESTOS DATOS SEGÚN TU CONFIGURACIÓN
    private static final String URL = "jdbc:mysql://localhost:3306/conexion_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "JHOJAN3102634360";
    
    // Lista predefinida de colores válidos
    private static final List<String> COLORES_VALIDOS = Arrays.asList(
        "Rojo", "Blanco", "Negro", "Azul", "Gris", "Verde", "Amarillo"
    );

    /**
     * Obtiene una conexión a la base de datos
     */
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver MySQL no encontrado", e);
        }
    }

    /**
     * Lista todos los vehículos.
     * @return Lista de vehículos
     * @throws SQLException si hay error de base de datos
     */
    public List<Vehiculo> listar() throws SQLException {
        try (Connection con = getConnection()) {
            VehiculoDAO dao = new VehiculoDAO(con);
            return dao.listar();
        }
    }

    /**
     * Busca vehículo por id.
     * @param id ID del vehículo
     * @return Vehiculo encontrado
     * @throws SQLException si hay error de base de datos
     */
    public Vehiculo buscarPorId(int id) throws SQLException {
        try (Connection con = getConnection()) {
            VehiculoDAO dao = new VehiculoDAO(con);
            return dao.buscarPorId(id);
        }
    }

    /**
     * Agrega vehículo con validación de reglas de negocio.
     * @param v Vehiculo a agregar
     * @throws BusinessException si se viola alguna regla de negocio
     * @throws SQLException si hay error de base de datos
     */
    public void agregar(Vehiculo v) throws BusinessException, SQLException {
        // Validar reglas de negocio
        validarReglasNegocio(v);
        
        try (Connection con = getConnection()) {
            VehiculoDAO dao = new VehiculoDAO(con);
            
            // Validar placa duplicada
            if (dao.existePlaca(v.getPlaca())) {
                throw new BusinessException("La placa " + v.getPlaca() + " ya está registrada");
            }
            
            dao.agregar(v);
            
            // Simular notificación para Ferrari
            if ("Ferrari".equalsIgnoreCase(v.getMarca())) {
                System.out.println("NOTIFICACIÓN: Se ha agregado un vehículo Ferrari - Placa: " + v.getPlaca());
            }
        }
    }

    /**
     * Actualiza vehículo con validación de reglas de negocio.
     * @param v Vehiculo a actualizar
     * @throws BusinessException si se viola alguna regla de negocio
     * @throws SQLException si hay error de base de datos
     */
    public void actualizar(Vehiculo v) throws BusinessException, SQLException {
        // Validar reglas de negocio
        validarReglasNegocio(v);
        
        try (Connection con = getConnection()) {
            VehiculoDAO dao = new VehiculoDAO(con);
            
            // Verificar que el vehículo existe
            Vehiculo existente = dao.buscarPorId(v.getId());
            if (existente == null) {
                throw new BusinessException("El vehículo con ID " + v.getId() + " no existe");
            }
            
            // Validar placa duplicada (excluyendo el propio vehículo)
            if (!existente.getPlaca().equals(v.getPlaca()) && dao.existeOtraPlaca(v.getPlaca(), v.getId())) {
                throw new BusinessException("La placa " + v.getPlaca() + " ya está registrada en otro vehículo");
            }
            
            dao.actualizar(v);
        }
    }

    /**
     * Elimina vehículo por id con validación de reglas de negocio.
     * @param id ID del vehículo a eliminar
     * @throws BusinessException si se viola alguna regla de negocio
     * @throws SQLException si hay error de base de datos
     */
    public void eliminar(int id) throws BusinessException, SQLException {
        try (Connection con = getConnection()) {
            VehiculoDAO dao = new VehiculoDAO(con);
            
            // Verificar que el vehículo existe
            Vehiculo existente = dao.buscarPorId(id);
            if (existente == null) {
                throw new BusinessException("El vehículo con ID " + id + " no existe");
            }
            
            // Validar que no se puede eliminar si el propietario es "Administrador"
            if ("Administrador".equalsIgnoreCase(existente.getPropietario())) {
                throw new BusinessException("No se puede eliminar un vehículo del propietario 'Administrador'");
            }
            
            dao.eliminar(id);
        }
    }

    /**
     * Valida todas las reglas de negocio para un vehículo
     * @param v Vehiculo a validar
     * @throws BusinessException si se viola alguna regla
     */
    private void validarReglasNegocio(Vehiculo v) throws BusinessException {
        // Validar propietario no vacío y mínimo 5 caracteres
        if (v.getPropietario() == null || v.getPropietario().trim().isEmpty()) {
            throw new BusinessException("El propietario no puede estar vacío");
        }
        if (v.getPropietario().trim().length() < 5) {
            throw new BusinessException("El propietario debe tener al menos 5 caracteres");
        }

        // Validar longitud mínima de marca, modelo y placa
        if (v.getMarca() == null || v.getMarca().trim().length() < 3) {
            throw new BusinessException("La marca debe tener al menos 3 caracteres");
        }
        if (v.getModelo() == null || v.getModelo().trim().length() < 3) {
            throw new BusinessException("El modelo debe tener al menos 3 caracteres");
        }
        if (v.getPlaca() == null || v.getPlaca().trim().length() < 3) {
            throw new BusinessException("La placa debe tener al menos 3 caracteres");
        }

        // Validar color en lista predefinida
        if (v.getColor() == null || !COLORES_VALIDOS.contains(v.getColor())) {
            throw new BusinessException("Color no válido. Colores permitidos: " + COLORES_VALIDOS);
        }

        // Validar antigüedad del modelo (máximo 20 años)
        int añoActual = Calendar.getInstance().get(Calendar.YEAR);
        if (v.getAño() < (añoActual - 20)) {
            throw new BusinessException("El vehículo no puede tener más de 20 años de antigüedad. Año mínimo permitido: " + (añoActual - 20));
        }
        
        // Validar que el año no sea mayor al actual
        if (v.getAño() > añoActual) {
            throw new BusinessException("El año no puede ser mayor al año actual (" + añoActual + ")");
        }

        // Validar SQL Injection (simulación básica)
        if (contienePalabrasPeligrosas(v.getPlaca()) || 
            contienePalabrasPeligrosas(v.getMarca()) || 
            contienePalabrasPeligrosas(v.getModelo()) ||
            contienePalabrasPeligrosas(v.getPropietario())) {
            throw new BusinessException("Los datos contienen caracteres no permitidos para seguridad");
        }
    }

    /**
     * Simula validación básica contra SQL Injection
     * @param input texto a validar
     * @return true si contiene palabras peligrosas
     */
    private boolean contienePalabrasPeligrosas(String input) {
        if (input == null) return false;
        
        String[] palabrasPeligrosas = {"SELECT", "INSERT", "DELETE", "UPDATE", "DROP", 
                                      "UNION", "OR", "AND", "--", "/*", "*/", ";", "="};
        
        String inputUpper = input.toUpperCase();
        for (String palabra : palabrasPeligrosas) {
            if (inputUpper.contains(palabra)) {
                return true;
            }
        }
        return false;
    }
}
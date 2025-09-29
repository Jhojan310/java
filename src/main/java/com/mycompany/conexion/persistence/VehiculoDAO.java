package com.mycompany.conexion.persistence;

import com.mycompany.conexion.model.Vehiculo;
import java.sql.*;
import java.util.*;

/**
 * DAO para la gestión de vehículos en la base de datos.
 * Todas las operaciones CRUD y de consulta deben manejar excepciones
 * y documentar los errores detectados.
 */
public class VehiculoDAO {
    private final Connection con;

    /**
     * Inicializa con una conexión JDBC ya creada.
     * @param con conexión activa a MySQL
     */
    public VehiculoDAO(Connection con) {
        this.con = con;
    }

    /**
     * Busca todos los vehículos en la base de datos.
     * @return Lista de Vehiculo o lista vacía.
     * @throws SQLException si hay error de conexión BD.
     */
    public List<Vehiculo> listar() throws SQLException {
        List<Vehiculo> lista = new ArrayList<>();
        String sql = "SELECT * FROM vehicles";
        try (Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Vehiculo v = new Vehiculo(
                    rs.getInt("id"),
                    rs.getString("placa"),
                    rs.getString("marca"),
                    rs.getString("modelo"),
                    rs.getString("color"),
                    rs.getInt("año"),
                    rs.getString("propietario")
                );
                lista.add(v);
            }
        } catch (SQLException ex) {
            // Manejo de error: loggear el error y relanzar
            System.err.println("Error al listar vehiculos: " + ex.getMessage());
            throw ex; // relanzar para manejar en capa superior
        }
        return lista;
    }

    /**
     * Busca un vehículo por ID.
     * @param id ID del vehículo a buscar
     * @return Vehiculo encontrado o null si no existe
     * @throws SQLException si hay error de base de datos
     */
    public Vehiculo buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM vehicles WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Vehiculo(
                    rs.getInt("id"),
                    rs.getString("placa"),
                    rs.getString("marca"),
                    rs.getString("modelo"),
                    rs.getString("color"),
                    rs.getInt("año"),
                    rs.getString("propietario")
                );
            }
        } catch (SQLException ex) {
            System.err.println("Error al buscar vehículo por id: " + ex.getMessage());
            throw ex;
        }
        return null;
    }

    /**
     * Verifica si ya existe una placa registrada. Útil para reglas de negocio.
     * @param placa placa a buscar
     * @return true si existe, false si no
     * @throws SQLException si hay error de base de datos
     */
    public boolean existePlaca(String placa) throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles WHERE placa=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, placa);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.err.println("Error al verificar placa: " + ex.getMessage());
            throw ex;
        }
        return false;
    }

    /**
     * Verifica si existe otra placa con el mismo valor (excluyendo un ID específico)
     * @param placa placa a verificar
     * @param excluirId ID a excluir de la verificación
     * @return true si existe otra placa igual
     * @throws SQLException si hay error de base de datos
     */
    public boolean existeOtraPlaca(String placa, int excluirId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles WHERE placa=? AND id != ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, placa);
            ps.setInt(2, excluirId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.err.println("Error al verificar placa duplicada: " + ex.getMessage());
            throw ex;
        }
        return false;
    }

    /**
     * Agrega un nuevo vehículo si la placa no existe. Lanzar SQLException si falla.
     * @param v Vehiculo a agregar
     * @throws SQLException si hay error de base de datos
     */
    public void agregar(Vehiculo v) throws SQLException {
        String sql = "INSERT INTO vehicles (placa, marca, modelo, color, año, propietario) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getModelo());
            ps.setString(4, v.getColor());
            ps.setInt(5, v.getAño());
            ps.setString(6, v.getPropietario());
            ps.executeUpdate();
        } catch (SQLException ex) {
            System.err.println("Error al agregar vehículo: " + ex.getMessage());
            throw ex;
        }
    }

    /** 
     * Actualiza todos los datos de un vehículo existente por id.
     * @param v Vehiculo con los datos actualizados
     * @throws SQLException si hay error de base de datos
     */
    public void actualizar(Vehiculo v) throws SQLException {
        String sql = "UPDATE vehicles SET placa=?, marca=?, modelo=?, color=?, año=?, propietario=? WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, v.getPlaca());
            ps.setString(2, v.getMarca());
            ps.setString(3, v.getModelo());
            ps.setString(4, v.getColor());
            ps.setInt(5, v.getAño());
            ps.setString(6, v.getPropietario());
            ps.setInt(7, v.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            System.err.println("Error al actualizar vehículo: " + ex.getMessage());
            throw ex;
        }
    }

    /** 
     * Borra un vehículo por id.
     * @param id ID del vehículo a eliminar
     * @throws SQLException si hay error de base de datos
     */
    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            System.err.println("Error al eliminar vehículo: " + ex.getMessage());
            throw ex;
        }
    }
}
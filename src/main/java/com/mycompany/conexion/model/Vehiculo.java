package com.mycompany.conexion.model;

/**
 * Entidad que representa un vehículo en el garaje.
 * Incluye atributos básicos y los métodos getter/setter.
 */
public class Vehiculo {
    private int id;
    private String placa;
    private String marca;
    private String modelo;
    private String color;
    private int año;
    private String propietario;

    /** Constructor vacío (requerido por JavaBeans) */
    public Vehiculo() {}

    /**
     * Constructor completo
     */
    public Vehiculo(int id, String placa, String marca, String modelo, 
                   String color, int año, String propietario) {
        this.id = id;
        this.placa = placa;
        this.marca = marca;
        this.modelo = modelo;
        this.color = color;
        this.año = año;
        this.propietario = propietario;
    }

    // Getters y setters con JavaDoc en cada uno
    
    /** @return id del vehículo */
    public int getId() { return id; }

    /** @param id establece el identificador único */
    public void setId(int id) { this.id = id; }

    /** @return placa del vehículo */
    public String getPlaca() { return placa; }

    /** @param placa establece la placa */
    public void setPlaca(String placa) { this.placa = placa; }

    /** @return marca del vehículo */
    public String getMarca() { return marca; }

    /** @param marca establece la marca */
    public void setMarca(String marca) { this.marca = marca; }

    /** @return modelo del vehículo */
    public String getModelo() { return modelo; }

    /** @param modelo establece el modelo */
    public void setModelo(String modelo) { this.modelo = modelo; }

    /** @return color del vehículo */
    public String getColor() { return color; }

    /** @param color establece el color */
    public void setColor(String color) { this.color = color; }

    /** @return año del vehículo */
    public int getAño() { return año; }

    /** @param año establece el año */
    public void setAño(int año) { this.año = año; }

    /** @return propietario del vehículo */
    public String getPropietario() { return propietario; }

    /** @param propietario establece el propietario */
    public void setPropietario(String propietario) { this.propietario = propietario; }
}
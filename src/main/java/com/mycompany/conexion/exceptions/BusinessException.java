package com.mycompany.conexion.exceptions;

/**
 * Excepción personalizada para errores de negocio
 */
public class BusinessException extends Exception {
    public BusinessException(String message) {
        super(message);
    }
    
    public BusinessException(String message, Throwable cause) {
        super(message, cause);
    }
}
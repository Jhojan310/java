Descripción del Proyecto
Sistema web desarrollado en Java EE para la gestión integral de vehículos en un garaje. Implementa una arquitectura en capas con persistencia, fachadas y controladores, incluyendo validaciones de negocio robustas.

Arquitectura del Sistema
src/main/java/com/mycompany/conexion/
├── model/           # Entidades del dominio
│   └── Vehiculo.java
├── persistence/     # Capa de acceso a datos (DAO)
│   └── VehiculoDAO.java
├── facade/         # Lógica de negocio y reglas
│   └── VehiculoFacade.java
├── exceptions/     # Excepciones personalizadas
│   └── BusinessException.java
└── controller/     # Controladores web (Servlets)
    └── VehiculoServlet.java

    Diagrama de Arquitectura
Cliente Web (JSP) 
    ↓ (HTTP Request/Response)
VehiculoServlet (Controller)
    ↓ (Llamadas a métodos)
VehiculoFacade (Business Layer)
    ↓ (Validaciones + Reglas Negocio)
VehiculoDAO (Persistence Layer)
    ↓ (JDBC)
Base de Datos MySQL


Base de datos
-- Crear base de datos
CREATE DATABASE IF NOT EXISTS conexion_db;
USE conexion_db;

-- Crear tabla
CREATE TABLE vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(20) NOT NULL UNIQUE,
    marca VARCHAR(30) NOT NULL,
    modelo VARCHAR(30) NOT NULL,
    color VARCHAR(20),
    año INT NOT NULL,
    propietario VARCHAR(50) NOT NULL
);



 Convenciones de Nombres
Java Classes
Entidades: Sustantivos en singular (Vehiculo)
DAO: [Entidad]DAO (VehiculoDAO)
Facade: [Entidad]Facade (VehiculoFacade)
Controllers: [Entidad]Servlet (VehiculoServlet)
Exceptions: [Tipo]Exception (BusinessException)
Métodos
CRUD: listar(), buscarPorId(), agregar(), actualizar(), eliminar()
Validaciones: validarReglasNegocio(), existePlaca()
Utilidades: getConnection(), contienePalabrasPeligrosas()
Variables
Camel Case: vehiculoFacade, listaVehiculos
Constantes: COLORES_VALIDOS, URL_CONEXION

Base de Datos
Tablas: Plural en inglés (vehicles)
Columnas: snake_case (id, placa, marca)

Reglas de Negocio Implementadas
Validaciones de Entrada
Placa única: No se permiten placas duplicadas

Longitud mínima:
Propietario: mínimo 5 caracteres
Marca/Modelo/Placa: mínimo 3 caracteres
Colores válidos: Solo se aceptan colores predefinidos
Antigüedad: Máximo 20 años de antigüedad
Año válido: No puede ser mayor al año actual

Restricciones de Operación
Eliminación: No se puede eliminar vehículos del propietario "Administrador"
Actualización: Solo si el vehículo existe
Seguridad: Validación básica contra SQL Injection
Notificaciones: Simulación de notificación para vehículos Ferrari

Cómo Ejecutar el Sistema

Prerrequisitos
Java JDK 11 o superior
Glassfish 
MySQL Server 8.x o superior
Maven 3.6+ (opcional)

Configuración de Conexión
private static final String URL = "jdbc:mysql://localhost:3306/conexion_db";
private static final String USER = "root";
private static final String PASSWORD = "JHOJAN_3102634360";

Capas de Manejo de Errores
DAO: Captura SQLException y relanza con logging
Facade: Valida reglas de negocio y lanza BusinessException
Controller: Captura excepciones y muestra mensajes amigables
Vista: Presenta errores de forma clara al usuario

Tipos de Excepciones
BusinessException: Errores de reglas de negocio
SQLException: Errores de base de datos
ServletException: Errores de la aplicación web

convenciones commits
feat: Implementa validación para evitar placas duplicadas
fix: Corrige error en actualización de vehículos
docs: Actualiza documentación del DAO
refactor: Mejora estructura de validaciones
test: Agrega pruebas para reglas de negocio

estructura de ramas
main
├── develop
│   ├── feature/validacion-placas
│   ├── feature/gestion-vehiculos
│   ├── bugfix/error-actualizacion
│   └── hotfix/critical-fix

dependencias:
<dependencies>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>4.0.1</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>
</dependencies>

Guía para Contribuir
Fork del repositorio
Crear rama feature: git checkout -b feature/AmazingFeature
Commit cambios: git commit -m 'Add AmazingFeature'
Push a la rama: git push origin feature/AmazingFeature
Abrir Pull Request

Diagramas:
# Diagramas UML - Sistema de Gestión de Vehículos

## 1. Diagrama de Clases
**Propósito:** Mostrar la estructura estática del sistema y relaciones entre clases.

**Elementos clave:**
- `Vehiculo`: Entidad principal del dominio
- `VehiculoDAO`: Capa de persistencia (Data Access Object)
- `VehiculoFacade`: Capa de lógica de negocio
- `VehiculoServlet`: Controlador web
- `BusinessException`: Manejo de errores de negocio

## 2. Diagrama de Secuencia - Crear Vehículo
**Propósito:** Mostrar el flujo de interacciones al crear un vehículo.

**Puntos importantes:**
- Validación de reglas de negocio antes de persistir
- Verificación de placa única
- Notificación especial para vehículos Ferrari

## 3. Diagrama de Secuencia - Eliminar Vehículo  
**Propósito:** Mostrar restricción de eliminación para propietario "Administrador".

**Puntos importantes:**
- Verificación de existencia del vehículo
- Validación de regla "No eliminar Administrador"
- Manejo diferenciado de casos

## 4. Diagrama de Componentes - Arquitectura
**Propósito:** Visualizar la arquitectura en capas del sistema.

**Capas identificadas:**
- Frontend (Vistas JSP)
- Controller (Servlet)
- Business Layer (Facade)
- Persistence Layer (DAO)
- Model (Entidades)

## 5. Diagrama de Flujo - Validación de Reglas
**Propósito:** Detallar el proceso de validación de reglas de negocio.

**Reglas validadas:**
1. Propietario mínimo 5 caracteres
2. Campos obligatorios mínimo 3 caracteres  
3. Color en lista predefinida
4. Antigüedad máxima 20 años
5. Prevención SQL Injection

## 6. Diagrama de Estados - Vehículo
**Propósito:** Mostrar los estados posibles de un vehículo en el sistema.

**Estados principales:**
- No Existente → Creado → En Sistema
- Flujos de edición y eliminación
- Manejo de errores de validación

# 🇻🇪 Módulo SQL: División Político-Territorial de Venezuela

Este módulo proporciona el esquema relacional completo y una amplia colección de consultas para la gestión de la división político-territorial de Venezuela, diseñado para **Microsoft SQL Server**.

## 📄 Descripción de Archivos

### 1. [venezuela.sql](./venezuela.sql)
Es el script principal de implementación del servidor. Este archivo automatiza todo el proceso de despliegue inicial:
- **DDL (Data Definition Language)**: Crea la base de datos `VenezuelaDB` y las tablas relacionales (`Estados`, `Municipios`, `Parroquias`, `Ciudades`) con sus respectivos índices y llaves foráneas.
- **DML (Data Manipulation Language)**: Puebla la base de datos con información geográfica precisa y actualizada.
- **Normalización**: Implementa una estructura robusta que permite vincular ciudades con sus respectivos municipios de forma lógica.

### 2. [VenezuelaQueries.sql](./VenezuelaQueries.sql)
Un kit de herramientas de consulta diseñado para analistas y desarrolladores. Contiene una colección de **12 consultas SQL** pre-optimizadas que cubren:
- Conteos generales y auditoría de datos.
- Vistas jerárquicas completas (**Estado > Municipio > Ciudad > Parroquia**).
- Identificación de ciudades capitales mediante lógica visual (Iconografía en resultados).
- Resúmenes estadísticos por estado.
- Consultas de filtrado inteligente por nombre o ID.

## 📊 Estadísticas del Dataset
| Entidad | Total |
| :--- | :--- |
| **Estados** | 24 |
| **Municipios** | 335 |
| **Parroquias** | 1139 |
| **Ciudades Totales** | 479 |
| **Ciudades Vinculadas** | 259 |

## 🛠️ Requisitos Técnicos
- **Motor**: SQL Server 2016 o superior.
- **Collation**: `Latin1_General_CI_AI` (Soporte completo para tildes y eñes).
- **Esquema**: `dbo`

## 🚀 Próximamente
- **Equivalencia en JSON**: Migración y exportación de toda la estructura relacional a formatos JSON estándar para integración con APIs REST y NoSQL.

---
> **Créditos**: Estructura SQL e implementación desarrollada por el **Ing. Juan C. Rodríguez**.

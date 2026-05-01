/* ============================================================
   HOTEL BOOKING ANALYSIS - MYSQL PROJECT
   Base de datos: hotel_booking
   Objetivo: análisis exploratorio
   ============================================================ */

-- ============================================================
-- 1. CARGA DE DATOS
-- ============================================================

-- Carga del dataset desde archivo CSV
LOAD DATA LOCAL INFILE 'ruta/dataset.csv'
INTO TABLE hotel
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
hotel, is_canceled, lead_time, arrival_date_year, arrival_date_month,
arrival_date_week_number, arrival_date_day_of_month,
stays_in_weekend_nights, stays_in_week_nights,
adults,
@children,
babies, meal, country, market_segment, distribution_channel,
is_repeated_guest, previous_cancellations, previous_bookings_not_canceled,
reserved_room_type, assigned_room_type, booking_changes,
deposit_type, agent, company, days_in_waiting_list,
customer_type, adr, required_car_parking_spaces,
total_of_special_requests, reservation_status, reservation_status_date
)
SET children = NULLIF(@children, 'NA');

-- ============================================================
-- 2. EXPLORACIÓN GENERAL
-- ============================================================

-- 2.1 Vista general de datos
SELECT * 
FROM hotel
LIMIT 100;

-- 2.2 Objetos dentro de la base de datos
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'hotel_booking';

-- ============================================================
-- 3. ESTRUCTURA DE LA TABLA
-- ============================================================

-- 3.1 Columnas de la tabla principal
SELECT 
    column_name,
    column_type,
    is_nullable,
    column_key,
    extra
FROM information_schema.columns
WHERE table_schema = 'hotel_booking'
AND table_name = 'hotel'
ORDER BY ordinal_position;

-- ============================================================
-- 4. EXPLORACIÓN DIMENSIONAL
-- ============================================================

-- 4.1 Países únicos
SELECT DISTINCT country
FROM hotel;

-- 4.2 Tipo de cliente
SELECT DISTINCT customer_type
FROM hotel;

-- 4.3 Tipo de hotel
SELECT DISTINCT hotel
FROM hotel;

-- 4.4 Segmentos de mercado
SELECT DISTINCT market_segment
FROM hotel;

-- ============================================================
-- 5. ANÁLISIS TEMPORAL
-- ============================================================

-- Rango de fechas del dataset
SELECT 
    MIN(reservation_status_date) AS fecha_min,
    MAX(reservation_status_date) AS fecha_max,
    TIMESTAMPDIFF(YEAR, MIN(reservation_status_date), MAX(reservation_status_date)) AS rango_anios
FROM hotel;

-- ============================================================
-- 6. MÉTRICAS GENERALES
-- ============================================================

SELECT 'Total reservas' AS métrica, COUNT(*) AS valor
FROM hotel

UNION ALL

SELECT 'Total cancelaciones', SUM(is_canceled)
FROM hotel

UNION ALL

SELECT 'Total personas',
       SUM(adults + IFNULL(children,0) + IFNULL(babies,0))
FROM hotel

UNION ALL

SELECT 'ADR promedio',
       ROUND(AVG(adr),2)
FROM hotel

UNION ALL

SELECT 'Lead time promedio',
       ROUND(AVG(lead_time),2)
FROM hotel;

-- ============================================================
-- 7. ANÁLISIS DE CANCELACIONES
-- ============================================================

-- 7.1 Canceladas vs no canceladas
SELECT
    is_canceled,
    COUNT(*) AS total
FROM hotel
GROUP BY is_canceled;

-- 7.2 Tasa general de cancelación
SELECT
    COUNT(*) AS total_reservas,
    SUM(is_canceled) AS canceladas,
    COUNT(*) - SUM(is_canceled) AS confirmadas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel;

-- ============================================================
-- 8. CANCELACIONES POR DIMENSIÓN
-- ============================================================

-- 8.1 Por tipo de hotel
SELECT
    hotel,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY hotel
ORDER BY pct_cancelacion DESC;

-- 8.2 Por año
SELECT
    arrival_date_year,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY arrival_date_year
ORDER BY arrival_date_year;

-- 8.3 Por mes
SELECT
    arrival_date_year,
    arrival_date_month,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year,
FIELD(arrival_date_month,
'January','February','March','April','May','June',
'July','August','September','October','November','December');

-- 8.4 Por anticipación (lead time)
SELECT
    CASE
        WHEN lead_time BETWEEN 0 AND 7 THEN '0-7 días'
        WHEN lead_time BETWEEN 8 AND 30 THEN '8-30 días'
        WHEN lead_time BETWEEN 31 AND 90 THEN '31-90 días'
        WHEN lead_time BETWEEN 91 AND 180 THEN '91-180 días'
        ELSE '+180 días'
    END AS rango_lead_time,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY rango_lead_time;

-- 8.5 Por tipo de depósito
SELECT
    deposit_type,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY deposit_type
ORDER BY pct_cancelacion DESC;

-- 8.6 Por segmento de mercado
SELECT
    market_segment,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY market_segment
ORDER BY pct_cancelacion DESC;

-- 8.7 Por tipo de cliente
SELECT
    customer_type,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY customer_type
ORDER BY pct_cancelacion DESC;

-- 8.8 Huésped repetido vs nuevo
SELECT
    CASE is_repeated_guest
        WHEN 1 THEN 'Repetido'
        ELSE 'Nuevo'
    END AS tipo_huesped,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY is_repeated_guest;

-- ============================================================
-- 9. CLIENTES Y COMPORTAMIENTO
-- ============================================================

-- 9.1 Solicitudes especiales
SELECT
    total_of_special_requests,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;

-- 9.2 Parking requerido
SELECT
    required_car_parking_spaces,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY required_car_parking_spaces;

-- 9.3 Historial de cancelaciones previas
SELECT
    CASE
        WHEN previous_cancellations = 0 THEN '0'
        WHEN previous_cancellations = 1 THEN '1'
        WHEN previous_cancellations BETWEEN 2 AND 3 THEN '2-3'
        ELSE '4+'
    END AS historial_cancelaciones,
    COUNT(*) AS total,
    SUM(is_canceled) AS canceladas,
    ROUND(SUM(is_canceled)*100/COUNT(*),2) AS pct_cancelacion
FROM hotel
GROUP BY historial_cancelaciones
ORDER BY pct_cancelacion DESC;

-- ============================================================
-- 10. PRECIOS Y ESTADÍA
-- ============================================================

-- 10.1 ADR según estado
SELECT
    CASE is_canceled WHEN 1 THEN 'Cancelada' ELSE 'Confirmada' END AS estado,
    ROUND(AVG(adr),2) AS adr_promedio
FROM hotel
GROUP BY is_canceled;

-- 10.2 ADR por hotel
SELECT
    hotel,
    CASE is_canceled WHEN 1 THEN 'Cancelada' ELSE 'Confirmada' END AS estado,
    ROUND(AVG(adr),2) AS adr_promedio
FROM hotel
GROUP BY hotel, is_canceled;

-- 10.3 Duración de estadía
SELECT
    CASE is_canceled WHEN 1 THEN 'Cancelada' ELSE 'Confirmada' END AS estado,
    ROUND(AVG(stays_in_week_nights + stays_in_weekend_nights),2) AS noches_totales,
    ROUND(AVG(stays_in_week_nights),2) AS noches_semana,
    ROUND(AVG(stays_in_weekend_nights),2) AS noches_fin_semana
FROM hotel
GROUP BY is_canceled;

-- ============================================================
-- 11. RESUMEN FINAL MULTIDIMENSIONAL
-- ============================================================

SELECT *
FROM (
    SELECT 'Tipo hotel' AS dimension, hotel AS valor,
           ROUND(SUM(is_canceled)*100/COUNT(*),1) AS pct
    FROM hotel
    GROUP BY hotel

    UNION ALL

    SELECT 'Depósito', deposit_type,
           ROUND(SUM(is_canceled)*100/COUNT(*),1)
    FROM hotel
    GROUP BY deposit_type

    UNION ALL

    SELECT 'Segmento mercado', market_segment,
           ROUND(SUM(is_canceled)*100/COUNT(*),1)
    FROM hotel
    GROUP BY market_segment

    UNION ALL

    SELECT 'Tipo cliente', customer_type,
           ROUND(SUM(is_canceled)*100/COUNT(*),1)
    FROM hotel
    GROUP BY customer_type

    UNION ALL

    SELECT 'Tipo comida', meal,
           ROUND(SUM(is_canceled)*100/COUNT(*),1)
    FROM hotel
    GROUP BY meal
) AS resumen
ORDER BY dimension, pct DESC;
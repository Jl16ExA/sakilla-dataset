-- Shows average payment per shop

-- Store | May2005  | June2005 | Difference1 | GrowthPercentage1 | July2005 | Difference2 | GrowthPercentage2

-- Each row:
-- - Store (Distrito, ciudad)
-- - May2005 (pago promedio por alquiler en Mayo de 2005 por cada tienda)
-- - June2005 (pago promedio por alquiler en Junio de 2005 por cada tienda)
-- - Difference1 -> JUNIO-MAYO
-- - growthPercentage1 -> (Junio-Mayo) / mayo
-- - July2005 (pago promedio por alquiler en Julio 2005 por cada tienda)
-- - Difference2 -> Julio- junio
-- - growthPercentage2 -> (Julio-Junio)/junio

WITH 
MayData AS (
    SELECT 
        CONCAT(a.district, ', ', c.city) AS Store,
        AVG(p.amount) AS MayAvgPayment
    FROM 
        payment p
    JOIN 
        rental r ON p.rental_id = r.rental_id
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    JOIN 
        store s ON i.store_id = s.store_id
    JOIN 
        address a ON s.address_id = a.address_id
    JOIN 
        city c ON a.city_id = c.city_id
    WHERE 
        MONTH(payment_date) = 5 AND YEAR(payment_date) = 2005
    GROUP BY 
        Store
),
JuneData AS (
    SELECT 
        CONCAT(a.district, ', ', c.city) AS Store,
        AVG(p.amount) AS JuneAvgPayment
    FROM 
        payment p
    JOIN 
        rental r ON p.rental_id = r.rental_id
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    JOIN 
        store s ON i.store_id = s.store_id
    JOIN 
        address a ON s.address_id = a.address_id
    JOIN 
        city c ON a.city_id = c.city_id
    WHERE 
        MONTH(payment_date) = 6 AND YEAR(payment_date) = 2005
    GROUP BY 
        Store
),
JulyData AS (
    SELECT 
        CONCAT(a.district, ', ', c.city) AS Store,
        AVG(p.amount) AS JulyAvgPayment
    FROM 
        payment p
    JOIN 
        rental r ON p.rental_id = r.rental_id
    JOIN 
        inventory i ON r.inventory_id = i.inventory_id
    JOIN 
        store s ON i.store_id = s.store_id
    JOIN 
        address a ON s.address_id = a.address_id
    JOIN 
        city c ON a.city_id = c.city_id
    WHERE 
        MONTH(payment_date) = 7 AND YEAR(payment_date) = 2005
    GROUP BY 
        Store
)
SELECT 
    m.Store,
    MayAvgPayment AS May2005,
    JuneAvgPayment AS June2005,
    JuneAvgPayment - MayAvgPayment AS Difference1,
    IF(MayAvgPayment = 0, NULL, ((JuneAvgPayment - MayAvgPayment) / MayAvgPayment) * 100) AS GrowthPercentage1,
    JulyAvgPayment AS July2005,
    JulyAvgPayment - JuneAvgPayment AS Difference2,
    IF(JuneAvgPayment = 0, NULL, ((JulyAvgPayment - JuneAvgPayment) / JuneAvgPayment) * 100) AS GrowthPercentage2
FROM 
    MayData m
JOIN 
    JuneData j ON m.Store = j.Store
JOIN 
    JulyData l ON m.Store = l.Store;

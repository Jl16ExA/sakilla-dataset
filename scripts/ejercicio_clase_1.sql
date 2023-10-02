-- 1. Cantidad de prestamos por cada tienda.
WITH 
MayLoans AS (
    SELECT 
        s.store_id,
        r.staff_id, 
        COUNT(*) AS MayLoansCount
    FROM 
        rental r
    JOIN 
        inventory i 
    ON 
        r.inventory_id = i.inventory_id
    JOIN
        staff s
    ON 
        r.staff_id = s.staff_id
    WHERE 
        MONTH(rental_date) = 5
    GROUP BY 
        s.store_id, r.staff_id
),
JuneLoans AS (
    SELECT 
        s.store_id,
        r.staff_id, 
        COUNT(*) AS JuneLoansCount
    FROM 
        rental r
    JOIN 
        inventory i 
    ON 
        r.inventory_id = i.inventory_id
    JOIN
        staff s
    ON 
        r.staff_id = s.staff_id
    WHERE 
        MONTH(rental_date) = 6
    GROUP BY 
        s.store_id, r.staff_id
)
SELECT 
    m.store_id AS Store,
    m.staff_id AS Vendor,
    COALESCE(MayLoansCount, 0) AS MayLoans,
    COALESCE(JuneLoansCount, 0) AS JuneLoans,
    COALESCE(JuneLoansCount, 0) - COALESCE(MayLoansCount, 0) AS Difference,
    IF(COALESCE(MayLoansCount,0) = 0, NULL, ((COALESCE(JuneLoansCount, 0) - COALESCE(MayLoansCount, 0)) / MayLoansCount) * 100) AS GrowthPercentage
FROM 
    MayLoans m
LEFT JOIN 
    JuneLoans j
ON 
    m.staff_id = j.staff_id
AND 
    m.store_id = j.store_id;


--- 2. 
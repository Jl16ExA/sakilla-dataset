WITH 
MayLoans AS (
    SELECT 
        i.store_id, 
        i.film_id, 
        COUNT(*) AS MayLoansCount
    FROM 
        rental r
    JOIN 
        inventory i 
    ON 
        r.inventory_id = i.inventory_id
    WHERE 
        MONTH(rental_date) = 5
    GROUP BY 
        i.store_id, i.film_id
),
JuneLoans AS (
    SELECT 
        i.store_id, 
        i.film_id, 
        COUNT(*) AS JuneLoansCount
    FROM 
        rental r
    JOIN 
        inventory i 
    ON 
        r.inventory_id = i.inventory_id
    WHERE 
        MONTH(rental_date) = 6
    GROUP BY 
        i.store_id, i.film_id
)
SELECT 
    f.title AS Movie,
    m.store_id AS Store,
    COALESCE(MayLoansCount, 0) AS MayLoans,
    COALESCE(JuneLoansCount, 0) AS JuneLoans,
    COALESCE(JuneLoansCount, 0) - COALESCE(MayLoansCount, 0) AS Difference,
    IF(COALESCE(MayLoansCount,0) = 0, NULL, ((COALESCE(JuneLoansCount, 0) - COALESCE(MayLoansCount, 0)) / MayLoansCount) * 100) AS GrowthPercentage
FROM 
    film f
JOIN 
    MayLoans m
ON 
    f.film_id = m.film_id
LEFT JOIN 
    JuneLoans j
ON 
    f.film_id = j.film_id
AND 
    m.store_id = j.store_id;

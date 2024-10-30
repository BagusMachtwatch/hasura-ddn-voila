WITH domain_counts AS (
    SELECT 
        SPLIT_PART(email, '@', 2) AS domain,
        COUNT(*) AS email_count
    FROM 
        customer
    WHERE email IS NOT NULL AND email != ''
    GROUP BY 
        domain
),
ranked_domains AS (
    SELECT 
        domain,
        email_count,
        ROW_NUMBER() OVER (ORDER BY email_count DESC) AS rank
    FROM 
        domain_counts
)
SELECT 
    CASE 
        WHEN rank <= 10 THEN domain 
        ELSE 'Others' 
    END AS domain,
    SUM(email_count) AS total
FROM 
    ranked_domains
GROUP BY 
    CASE 
        WHEN rank <= 10 THEN domain 
        ELSE 'Others' 
    END
ORDER BY
    total DESC;
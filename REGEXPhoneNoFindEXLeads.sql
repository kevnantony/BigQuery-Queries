-- SELECT  FROM `test-project-122123.holiday_tribe_db.standardized_leads_data` LIMIT 1000



WITH ranked_data AS (
    SELECT
        user_ns,
        DATE(date) AS conv_date,
        RIGHT(REGEXP_REPLACE(payload, r'[^\d]', ''), 10) AS standardized_phone, -- Using REGEXP_REPLACE to remove non-digit characters, then RIGHT to get the last 10 digits
        ROW_NUMBER() OVER (PARTITION BY user_ns ORDER BY date DESC, time DESC) AS row_num
    FROM
        `test-project-122123.holiday_tribe_db.f72973_conv_data`
    WHERE 
        REGEXP_CONTAINS(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}')
        AND payload NOT LIKE "%Thanks for your holiday details%"
        AND DATE(date) = '2024-03-04'
)
SELECT
    r.*
FROM
    ranked_data r
LEFT JOIN
    `test-project-122123.holiday_tribe_db.standardized_leads_data` s
ON
    r.standardized_phone = s.standardized_phone
WHERE
    r.row_num = 1
    AND s.standardized_phone IS NULL;



























WITH ranked_data AS (
    SELECT
        user_ns,
        DATE(date) AS conv_date,
        RIGHT(REGEXP_REPLACE(payload, r'[^\d]', ''), 10) AS standardized_phone, -- Using REGEXP_REPLACE to remove non-digit characters, then RIGHT to get the last 10 digits
        ROW_NUMBER() OVER (PARTITION BY user_ns ORDER BY date DESC, time DESC) AS row_num
    FROM
        `test-project-122123.holiday_tribe_db.f72973_conv_data`
    WHERE 
        NOT (RIGHT(REGEXP_REPLACE(payload, r'[^\d]', ''), 10) LIKE '1%')
        AND REGEXP_CONTAINS(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}')
        AND payload NOT LIKE "%Thanks for your holiday details%"
        AND DATE(date) between '2024-02-01' and '2024-02-29'
)
SELECT
    r.*
FROM
    ranked_data r
LEFT JOIN
    `test-project-122123.holiday_tribe_db.standardized_leads_data` s
ON
    r.standardized_phone = s.standardized_phone
WHERE
    r.row_num = 1
    AND s.standardized_phone IS NULL;







-- WITH ranked_data AS (
--     SELECT
--         user_ns,
--         DATE(date) AS conv_date,
--         -- Using REGEXP_REPLACE to remove non-digit characters, 
--         -- then extracting the last 10 digits.
--         -- First, ensure the payload is reduced to digits only for correct length-check and extraction.
--         CASE 
--             WHEN NOT RIGHT(REGEXP_REPLACE(payload, r'[^\d]', ''), 11) LIKE '1%' 
--             THEN RIGHT(REGEXP_REPLACE(payload, r'[^\d]', ''), 10) 
--         END AS standardized_phone,
--         ROW_NUMBER() OVER (PARTITION BY user_ns ORDER BY date DESC, time DESC) AS row_num
--     FROM
--         `test-project-122123.holiday_tribe_db.f72973_conv_data`
--     -- Assuming each payload contains a phone number alongside text, hence the REGEXP usage for extraction.
--     WHERE 
--         REGEXP_CONTAINS(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}')
--         AND payload NOT LIKE "%Thanks for your holiday details%"
--         AND DATE(date) BETWEEN '2024-02-01' AND '2024-03-08'
-- )
-- SELECT
--     r.user_ns,
--     r.conv_date,
--     r.standardized_phone
-- FROM
--     ranked_data r
-- LEFT JOIN
--     `test-project-122123.holiday_tribe_db.standardized_leads_data` s
-- ON
--     r.standardized_phone = s.standardized_phone
-- WHERE
--     r.row_num = 1
--     AND s.standardized_phone IS NULL
--     AND r.standardized_phone IS NOT NULL; -- Make sure to exclude rows where standardized_phone could be NULL



SELECT *
FROM `test-project-122123.holiday_tribe_db.leads_data`
WHERE date='2024-03-06'



SELECT ld.user_ns
FROM test-project-122123.holiday_tribe_db.leads_data ld
LEFT JOIN test-project-122123.holiday_tribe_db.f72973_conv_data fd
    ON ld.user_ns = fd.user_ns AND DATE(fd.date) = '2024-03-06'
WHERE fd.user_ns IS NULL;





-- SELECT  FROM `test-project-122123.holiday_tribe_db.standardized_leads_data` 


WITH ranked_data AS (
    SELECT
        user_ns,
        DATE(date) AS conv_date,
        RIGHT(REPLACE(REPLACE(REPLACE(REGEXP_EXTRACT(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}'), ' ', ''), '+', ''), '+91', ''), 10) AS standardized_phone,
        ROW_NUMBER() OVER (PARTITION BY user_ns ORDER BY date DESC, time DESC) AS row_num
    FROM
        `test-project-122123.holiday_tribe_db.f72973_conv_data`
    WHERE 
        REGEXP_CONTAINS(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}')
        AND payload NOT LIKE "%Thanks for your holiday details%"
        AND DATE(date) = '2024-03-04'
)
SELECT
    r.*
FROM
    ranked_data r
LEFT JOIN
    `test-project-122123.holiday_tribe_db.standardized_leads_data` s
ON
    r.standardized_phone = s.standardized_phone
WHERE
    r.row_num = 1
    AND s.standardized_phone IS NULL;





CREATE OR REPLACE TABLE `test-project-122123.holiday_tribe_db.standardized_leads_data` AS
SELECT
  user_ns,
  PARSE_DATE("%d-%m-%Y", date) AS conv_date,
  RIGHT(phone_number, 10) AS standardized_phone -- Adjusted to collect the last 10 digits
FROM
  `test-project-122123.holiday_tribe_db.leads_data`;















WITH ranked_data AS (
    SELECT
        user_ns,
        DATE(date) AS conv_date,
        RIGHT(REPLACE(REPLACE(REPLACE(REGEXP_EXTRACT(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}'), ' ', ''), '+', ''), '+91', ''), 10) AS phone, -- Correctly extracting and transforming the phone
        ROW_NUMBER() OVER (PARTITION BY user_ns ORDER BY date DESC, time DESC) AS row_num
    FROM
        `test-project-122123.holiday_tribe_db.f72973_conv_data`
    WHERE 
        REGEXP_CONTAINS(payload, r'(?:\+91)?\s*(?:[2-9]\s*){1}(?:\d\s*){9}')
        AND payload NOT LIKE "%Thanks for your holiday details%"
        AND DATE(date) = '2024-03-04'
), leads_data_transformed AS (
    SELECT
        phone_number,
        PARSE_DATE("%d-%m-%Y", date) AS leads_date -- Converts string date format to DATE type
    FROM
        `test-project-122123.holiday_tribe_db.leads_data`
)
SELECT
    r.user_ns,
    r.conv_date,
    r.phone
FROM
    ranked_data r
WHERE
    r.row_num = 1
    AND NOT EXISTS (
        SELECT 1
        FROM leads_data_transformed l
        WHERE
            (l.phone_number LIKE CONCAT('%', r.phone) OR l.phone_number LIKE CONCAT(r.phone, '%'))
            AND l.leads_date = r.conv_date
    );





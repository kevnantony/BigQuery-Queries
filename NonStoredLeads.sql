SELECT *
FROM `test-project-122123.holiday_tribe_db.conversation_data`
WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}')
-- AND payload is not like 'Phone no: NA'




SELECT *,
       REGEXP_EXTRACT(payload, r'Phone no: ([0-9]{10})') AS phone
FROM `test-project-122123.holiday_tribe_db.conversation_data`
WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}');





SELECT *,
       REGEXP_EXTRACT(payload, r'Phone no: ([0-9]{10})') AS phone
FROM `test-project-122123.holiday_tribe_db.conversation_data`
WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}') 
and DATE(date) BETWEEN '2024-02-01' AND '2024-02-26';






SELECT c.phone 
FROM (
    SELECT *,
          REGEXP_EXTRACT(payload, r'Phone no: ([0-9]{10})') AS phone
    FROM `test-project-122123.holiday_tribe_db.conversation_data`
    WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}')
    AND DATE(date) BETWEEN '2024-02-01' AND '2024-02-26'
) c
LEFT JOIN `test-project-122123.holiday_tribe_db.leads_data` l
ON c.phone = l.phone_number
WHERE l.phone_number IS NULL 









  

SELECT DISTINCT (phone_number)
FROM `test-project-122123.holiday_tribe_db.leads_data`
WHERE EXTRACT(MONTH FROM PARSE_DATE('%d-%m-%Y', date)) = 2;










SELECT 
    c.user_id,c.date,c.time, c.phone, 
    REGEXP_EXTRACT(c.payload, r'Name: ([^,]+)') AS name,
FROM (
    SELECT *,
          REGEXP_EXTRACT(payload, r'Phone no: ([0-9]{10})') AS phone
    FROM `test-project-122123.holiday_tribe_db.conversation_data`
    WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}')
    AND DATE(date) BETWEEN '2024-02-01' AND '2024-02-26'
) c
LEFT JOIN `test-project-122123.holiday_tribe_db.leads_data` l
ON c.phone = l.phone_number
WHERE l.phone_number IS NULL











SELECT 
    c.user_id,c.user_ns, c.session_id, c.date,c.time, c.phone, 
    REGEXP_EXTRACT(c.payload, r'Name: ([^,]+)') AS name,
FROM (
    SELECT *,
          REGEXP_EXTRACT(payload, r'Phone no: ([0-9]{10})') AS phone
    FROM `test-project-122123.holiday_tribe_db.conversation_data`
    WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}')
    AND DATE(date) BETWEEN '2024-02-01' AND '2024-02-26'
) c
LEFT JOIN `test-project-122123.holiday_tribe_db.leads_data` l
ON c.phone = l.phone_number
WHERE l.phone_number IS NULL













SELECT 
    c.user_id,c.user_ns, c.session_id, c.date,c.time, c.phone, 
    REGEXP_EXTRACT(c.payload, r'Name: ([^,]+)') AS name,
    REGEXP_EXTRACT(c.payload, r'Destination: \[([^]]+)\]') AS destination,
    REGEXP_EXTRACT(c.payload, r'NO_DAYS: ([^,]+)') AS no_days,
    REGEXP_EXTRACT(c.payload, r'Departure_Date: ([^}]+)') AS departure_date,


FROM (
    SELECT *,
          REGEXP_EXTRACT(payload, r'Phone no: ([0-9]{10})') AS phone
    FROM `test-project-122123.holiday_tribe_db.conversation_data`
    WHERE REGEXP_CONTAINS(payload, r'Phone no: [0-9]{10}')
    AND DATE(date) BETWEEN '2024-01-31' AND '2024-02-27'
) c
LEFT JOIN `test-project-122123.holiday_tribe_db.leads_data` l
ON c.phone = l.phone_number
WHERE l.phone_number IS NULL







SELECT  FROM `test-project-122123.holiday_tribe_db.f72973_conv_data` LIMIT 1000


WITH UniqueUsers AS (
  SELECT
    DATE AS Date,
    COUNT(DISTINCT user_id) AS Total_Leads
  FROM  
    `test-project-122123.holiday_tribe_db.f72973_conv_data`
  GROUP BY
    Date 
),

ExtractedNumbers AS (
  SELECT
    DATE(date) AS Date,
    COUNT(DISTINCT REGEXP_EXTRACT(payload, r'\b\d{10}\b')) AS Phone_Numbers_Captured
  FROM
    `test-project-122123.holiday_tribe_db.f72973_conv_data`,
    UNNEST(REGEXP_EXTRACT_ALL(payload, r'\b\d{10}\b')) AS number
  GROUP BY
    Date
),
PopularPackagesMessages AS (
  SELECT
    DATE(date) AS Date,
    COUNT(DISTINCT user_id) AS Carousel_Sent
  FROM
    `test-project-122123.holiday_tribe_db.f72973_conv_data`
  WHERE
    payload LIKE '%Please wait while we find the popular packages%'
  GROUP BY
    Date
),
InfoGiven AS (
  SELECT
    DATE(date) AS Date,
    COUNT(*) AS Info_Given
  FROM
    `test-project-122123.holiday_tribe_db.f72973_conv_data`
  WHERE
    payload LIKE '%affirmation%'
  GROUP BY
    Date
)


SELECT
  UU.Date,
  UU.Total_Leads,
  COALESCE(ENN.Phone_Numbers_Captured, 0) AS Phone_Numbers_Captured,
  COALESCE(PPM.Carousel_Sent, 0) AS Carousel_Sent,
  COALESCE(IG.Info_Given, 0) AS Info_Given
FROM
  UniqueUsers UU
LEFT JOIN
  ExtractedNumbers ENN ON UU.Date = ENN.Date
LEFT JOIN
  PopularPackagesMessages PPM ON UU.Date = PPM.Date
LEFT JOIN
  InfoGiven IG ON UU.Date = IG.Date
ORDER BY
  UU.Date;





SELECT *
From `test-project-122123.holiday_tribe_db.conversation_data`
WHERE DATE(date) between '2024-02-28' and '2024-02-28'





SELECT table2.user_id
FROM `test-project-122123.holiday_tribe_db.conversation_data` table2
LEFT JOIN `test-project-122123.holiday_tribe_db.f72973_conv_data` table1 ON table1.user_id = table2.user_id
WHERE table1.user_id IS NULL AND DATE(table1.date) = '2024-02-28';





SELECT * 
FROM `test-project-122123.holiday_tribe_db.f72973_conv_data`
where user_id='7448588885180070'



SELECT * FROM `test-project-122123.holiday_tribe_db.f72973_conv_data`
where user_id like'%717472954598164%' or '%689499353061054%'

SELECT * 
FROM `test-project-122123.holiday_tribe_db.f72973_conv_data` 
WHERE user_id LIKE '%717472954598164%' OR user_id LIKE '%689499353061054%'


select *
FROM `test-project-122123.holiday_tribe_db.conversation_data` 
where user_id='6894993530610542'




SELECT DISTINCT
    user_id,
    ARRAY(
        SELECT DISTINCT REGEXP_EXTRACT(payload, r'(\d{10})') AS phone_number
        FROM `test-project-122123.holiday_tribe_db.f72973_conv_data` AS c
        WHERE c.user_id = main.user_id
          AND REGEXP_CONTAINS(payload, r'\d{10}')
    ) AS phone_numbers
FROM `test-project-122123.holiday_tribe_db.f72973_conv_data` AS main




SELECT 
    user_id,
    ARRAY(
        SELECT DISTINCT phone_number
        FROM UNNEST((
            SELECT ARRAY_AGG(REGEXP_EXTRACT(payload, r'(\d{10})'))
            FROM `test-project-122123.holiday_tribe_db.f72973_conv_data` AS inner_c
            WHERE inner_c.user_id = main.user_id
              AND REGEXP_CONTAINS(payload, r'\d{10}')
        )) AS phone_numbers
FROM (
    SELECT DISTINCT user_id
    FROM `test-project-122123.holiday_tribe_db.f72973_conv_data`
) AS main








SELECT 
    user_id,
    payload,
    REGEXP_EXTRACT(payload, r'\b\d{10}\b') AS phone
FROM `test-project-122123.holiday_tribe_db.f72973_conv_data`
WHERE REGEXP_CONTAINS(payload, r'\b\d{10}\b')








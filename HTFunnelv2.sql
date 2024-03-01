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
    DATE(PARSE_DATE('%d-%m-%Y', date)) AS Date,
    COUNT(DISTINCT phone_number) as Info_Given
  FROM `test-project-122123.holiday_tribe_db.leads_data` 
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


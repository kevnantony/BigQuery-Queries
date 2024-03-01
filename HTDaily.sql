SELECT count(distinct user_id) FROM `test-project-122123.holiday_tribe_db.f72973_user_data` 
where date(date)= '2024-02-29' and channel = "instagram"


SELECT COUNT(*)
FROM `test-project-122123.holiday_tribe_db.f72973_conv_data` AS conv_data
JOIN `test-project-122123.holiday_tribe_db.f72973_user_data` AS user_data
ON conv_data.user_id = user_data.user_id AND conv_data.user_ns = user_data.user_ns
WHERE REGEXP_CONTAINS(conv_data.payload, r'[0-9]{10}')
AND user_data.channel = 'instagram'
AND user_data.date = '2024-02-29';


SELECT count(distinct phone_number) FROM `test-project-122123.holiday_tribe_db.leads_data` 
where date='29-02-2024'


-- Response Time between 2 payloads using keyword search and is_bot=no

WITH 
conversation_data_with_datetime AS (
  SELECT 
    user_id, 
    session_id, 
    payload,
    is_bot, 
    PARSE_DATETIME('%Y-%m-%d %H:%M:%S', CONCAT(CAST(date AS STRING), ' ', CAST(time AS STRING))) AS datetime
  FROM 
    `test-project-122123.holiday_tribe_db.conversation_data`
),
bot_user_conversations AS (
  SELECT 
    B.user_id,
    B.session_id,
    B.datetime AS bot_reply_time,
    B.payload AS bot_reply_payload,
    MAX(U.datetime) AS user_message_time ,
    MAX(U.payload) AS user_message_payload
  FROM 
    conversation_data_with_datetime AS B
  INNER JOIN 
    conversation_data_with_datetime AS U
  ON 
    B.user_id = U.user_id AND 
    B.session_id = U.session_id AND 
    B.is_bot = 'yes' AND 
    U.is_bot = 'no' AND 
    U.datetime < B.datetime
  GROUP BY 
    B.user_id, 
    B.session_id, 
    B.datetime,
    B.payload
)
SELECT 
  user_id, 
  session_id, 
  bot_reply_time,
  bot_reply_payload,
  user_message_time,
  user_message_payload,
  TIMESTAMP_DIFF(bot_reply_time, user_message_time, SECOND) AS response_time_seconds
FROM 
  bot_user_conversations

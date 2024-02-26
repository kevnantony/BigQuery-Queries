-- SELECT  FROM `test-project-122123.elivaas_db.conversation_data` LIMIT 1000


-- WITH RankedConversations AS (
--   SELECT
--     *,
--     LAG(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS previous_payload
--   FROM  `test-project-122123.elivaas_db.conversation_data`
-- )
-- SELECT
--   date,
--   time,
--   session_id,
--   user_id,
--   user_ns,
--   blog_url,
--   payload,
--   is_bot,
--   is_llm,
--   ai_input_tokens,
--   ai_output_tokens,
--   ai_params,
--   language
-- FROM RankedConversations
-- WHERE previous_payload = 'Great! Let\'s start with your name. May I know your full name, please?'







-- WITH ConversationStep AS (
--   SELECT
--     *,
--     -- Use LEAD() to fetch details of the next interaction by the same user
--     LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
--     LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
--     LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time,
--     LEAD(session_id) OVER(PARTITION BY user_id ORDER BY date, time) AS next_session_id,
--     LEAD(user_ns) OVER(PARTITION BY user_id ORDER BY date, time) AS next_user_ns,
--     LEAD(blog_url) OVER(PARTITION BY user_id ORDER BY date, time) AS next_blog_url,
--     LEAD(is_bot) OVER(PARTITION BY user_id ORDER BY date, time) AS next_is_bot,
--     LEAD(is_llm) OVER(PARTITION BY user_id ORDER BY date, time) AS next_is_llm,
--     LEAD(ai_input_tokens) OVER(PARTITION BY user_id ORDER BY date, time) AS next_ai_input_tokens,
--     LEAD(ai_output_tokens) OVER(PARTITION BY user_id ORDER BY date, time) AS next_ai_output_tokens,
--     LEAD(ai_params) OVER(PARTITION BY user_id ORDER BY date, time) AS next_ai_params,
--     LEAD(language) OVER(PARTITION BY user_id ORDER BY date, time) AS next_language
--   FROM `test-project-122123.allohealth_db.conversation_data`
-- )
-- SELECT
--   next_date AS date,
--   next_time AS time,
--   next_session_id AS session_id,
--   user_id,
--   next_user_ns AS user_ns,
--   next_blog_url AS blog_url,
--   next_payload AS payload,
--   next_is_bot AS is_bot,
--   next_is_llm AS is_llm,
--   next_ai_input_tokens AS ai_input_tokens,
--   next_ai_output_tokens AS ai_output_tokens,
--   next_ai_params AS ai_params,
--   next_language AS language
-- FROM ConversationStep
-- WHERE payload = 'Great! Let\'s start with your name. May I know your full name, please?'




-- WITH TargetPayloads AS (
--   SELECT
--     user_id,
--     date,
--     time
--   FROM `test-project-122123.allohealth_db.conversation_data`
--   WHERE payload = 'Great! Let\'s start with your name. May I know your full name, please?'
-- ),
-- NextEntries AS (
--   SELECT
--     a.user_id,
--     a.date AS next_date,
--     a.time AS next_time,
--     a.session_id AS next_session_id,
--     a.user_ns AS next_user_ns,
--     a.blog_url AS next_blog_url,
--     a.payload AS next_payload,
--     a.is_bot AS next_is_bot,
--     a.is_llm AS next_is_llm,
--     a.ai_input_tokens AS next_ai_input_tokens,
--     a.ai_output_tokens AS next_ai_output_tokens,
--     a.ai_params AS next_ai_params,
--     a.language AS next_language
--   FROM `test-project-122123.allohealth_db.conversation_data` a
--   JOIN TargetPayloads b ON a.user_id = b.user_id
--   WHERE ((a.date = b.date AND a.time > b.time) OR (a.date > b.date)) AND a.payload LIKE '%hi im tanya%'
-- ),
-- RankedNextEntries AS (
--   SELECT
--     *,
--     ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY next_date, next_time) AS rank
--   FROM NextEntries
-- )
-- SELECT
--   user_id,
--   next_date AS date,
--   next_time AS time,
--   next_session_id AS session_id,
--   next_user_ns AS user_ns,
--   next_blog_url AS blog_url,
--   next_payload AS payload,
--   next_is_bot AS is_bot,
--   next_is_llm AS is_llm,
--   next_ai_input_tokens AS ai_input_tokens,
--   next_ai_output_tokens AS ai_output_tokens,
--   next_ai_params AS ai_params,
--   next_language AS language
-- FROM RankedNextEntries
-- WHERE rank = 1






-- WITH TargetPayloads AS (
--   SELECT
--     user_id,
--     date,
--     time,
--     "Great! Let's start with your name. May I know your full name, please?" AS target_payload
--   FROM `test-project-122123.allohealth_db.conversation_data`
--   WHERE payload = 'Great! Let\'s start with your name. May I know your full name, please?'
-- ),
-- NextEntries AS (
--   SELECT
--     a.user_id,
--     a.date AS next_date,
--     a.time AS next_time,
--     a.session_id AS next_session_id,
--     a.user_ns AS next_user_ns,
--     a.blog_url AS next_blog_url,
--     a.payload AS next_payload,
--     a.is_bot AS next_is_bot,
--     a.is_llm AS next_is_llm,
--     a.ai_input_tokens AS next_ai_input_tokens,
--     a.ai_output_tokens AS next_ai_output_tokens,
--     a.ai_params AS next_ai_params,
--     a.language AS next_language
--   FROM `test-project-122123.allohealth_db.conversation_data` a
--   JOIN TargetPayloads b ON a.user_id = b.user_id
--   WHERE (a.date > b.date) OR (a.date = b.date AND a.time > b.time)
-- ),
-- RankedNextEntries AS (
--   SELECT
--     *,
--     ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY next_date, next_time) AS rank
--   FROM NextEntries
-- )
-- SELECT
--   user_id,
--   next_date AS date,
--   next_time AS time,
--   next_session_id AS session_id,
--   next_user_ns AS user_ns,
--   next_blog_url AS blog_url,
--   next_payload AS payload,
--   next_is_bot AS is_bot,
--   next_is_llm AS is_llm,
--   next_ai_input_tokens AS ai_input_tokens,
--   next_ai_output_tokens AS ai_output_tokens,
--   next_ai_params AS ai_params,
--   next_language AS language
-- FROM RankedNextEntries
-- WHERE rank = 1






-- WITH TargetPayloads AS (
--   SELECT
--     user_id,
--     date,
--     time
--   FROM `test-project-122123.allohealth_db.conversation_data`
--   WHERE payload LIKE '%hi im tanya%'
-- ),
-- NextEntries AS (
--   SELECT
--     a.user_id,
--     a.date AS next_date,
--     a.time AS next_time,
--     a.session_id AS next_session_id,
--     a.user_ns AS next_user_ns,
--     a.blog_url AS next_blog_url,
--     a.payload AS next_payload,
--     a.is_bot AS next_is_bot,
--     a.is_llm AS next_is_llm,
--     a.ai_input_tokens AS next_ai_input_tokens,
--     a.ai_output_tokens AS next_ai_output_tokens,
--     a.ai_params AS next_ai_params,
--     a.language AS next_language
--   FROM `test-project-122123.allohealth_db.conversation_data` a
--   JOIN TargetPayloads b ON a.user_id = b.user_id
--   WHERE (a.date > b.date OR (a.date = b.date AND a.time > b.time))
-- ),
-- RankedNextEntries AS (
--   SELECT
--     *,
--     ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY next_date, next_time) AS rank
--   FROM NextEntries
-- )
-- SELECT
--   user_id,
--   next_date AS date,
--   next_time AS time,
--   next_session_id AS session_id,
--   next_user_ns AS user_ns,
--   next_blog_url AS blog_url,
--   next_payload AS payload,
--   next_is_bot AS is_bot,
--   next_is_llm AS is_llm,
--   next_ai_input_tokens AS ai_input_tokens,
--   next_ai_output_tokens AS ai_output_tokens,
--   next_ai_params AS ai_params,
--   next_language AS language
-- FROM RankedNextEntries
-- WHERE rank = 1



-- WITH TargetedInteractions AS (
--   SELECT
--     user_id,
--     -- Capture the timestamp of the targeted payload
--     TIMESTAMP(date, time) as targeted_timestamp
--   FROM `test-project-122123.elivaas_db.conversation_data`
--   WHERE payload LIKE '%hi im tanya%'
-- ),
-- NextEntries AS (
--   SELECT
--     cd.*,
--     -- Using TIMESTAMP to compare datetime directly
--     TIMESTAMP(cd.date, cd.time) as entry_timestamp,
--     TI.targeted_timestamp
--   FROM `test-project-122123.elivaas_db.conversation_data` cd
--   JOIN TargetedInteractions TI ON cd.user_id = TI.user_id
--   -- Ensure we are looking at the entries after the target payload
--   WHERE TIMESTAMP(cd.date, cd.time) > TI.targeted_timestamp
-- ),
-- RankedNextEntries AS (
--   SELECT
--     *,
--     -- Rank entries by their timestamp to find the immediate next entry after "hi im tanya"
--     ROW_NUMBER() OVER(PARTITION BY user_id, targeted_timestamp ORDER BY entry_timestamp) AS rank
--   FROM NextEntries
-- )
-- -- Select only the first subsequent entry after each targeted interaction
-- SELECT
--   user_id,
--   DATE(entry_timestamp) AS date,
--   TIME(entry_timestamp) AS time,
--   session_id,
--   user_ns,
--   payload,
--   is_bot,
--   is_llm,
--   ai_input_tokens,
--   ai_output_tokens,
--   ai_params,
--   num_que_asked,
--   info_collection_end
-- FROM RankedNextEntries
-- WHERE rank = 1;






-- WITH TargetedInteractions AS (
--   SELECT
--     user_id,
--     -- Correctly combine date and time into a TIMESTAMP
--     TIMESTAMP(CAST(date AS STRING) || ' ' || CAST(time AS STRING)) as targeted_timestamp
--   FROM `test-project-122123.elivaas_db.conversation_data`
--   WHERE payload LIKE '%hi im tanya%'
-- ),
-- NextEntries AS (
--   SELECT
--     cd.*,
--     -- Correctly create a TIMESTAMP for comparison
--     TIMESTAMP(CAST(cd.date AS STRING) || ' ' || CAST(cd.time AS STRING)) as entry_timestamp,
--     TI.targeted_timestamp
--   FROM `test-project-122123.elivaas_db.conversation_data` cd
--   JOIN TargetedInteractions TI ON cd.user_id = TI.user_id
--   WHERE TIMESTAMP(CAST(cd.date AS STRING) || ' ' || CAST(cd.time AS STRING)) > TI.targeted_timestamp
-- ),
-- RankedNextEntries AS (
--   SELECT
--     *,
--     -- Rank entries by their timestamp to find the immediate next entry after "hi im tanya"
--     ROW_NUMBER() OVER(PARTITION BY user_id, targeted_timestamp ORDER BY entry_timestamp) AS rank
--   FROM NextEntries
-- )
-- SELECT
--   user_id,
--   DATE(entry_timestamp) AS date,
--   TIME(entry_timestamp) AS time,
--   session_id,
--   user_ns,
--   payload,
--   is_bot,
--   is_llm,
--   ai_input_tokens,
--   ai_output_tokens,
--   ai_params,
--   num_que_asked,
--   info_collection_end
-- FROM RankedNextEntries
-- WHERE rank = 1;






-- Answers for Name.

WITH NextUserEntries AS (
  SELECT
    *,
    -- Use LEAD to get the next payload for comparison based on user_id ordering by date and time
    LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
    -- Also, track the next entry's date and time for further clarification or usage
    LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
    LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
)
-- Select rows where the current row's payload matches the given text to find what follows it
SELECT
  date,
  time,
  session_id,
  user_id,
  user_ns,
  payload,
  is_bot,
  is_llm,
  ai_input_tokens,
  ai_output_tokens,
  ai_params,
  num_que_asked,
  info_collection_end,
  next_payload,
  next_date,
  next_time
FROM NextUserEntries
WHERE payload = "Great! Let's start with your name. May I know your full name, please?"






-- Answers for Destination.

WITH NextUserEntries AS (
  SELECT
    *,
    -- Use LEAD to look ahead at the next payload
    LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
    -- Additionally, get the next row's basic conversation details for context
    LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
    LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
)
-- Now we filter rows where the payload contains the specific substring we're interested in.
SELECT
  date,
  time,
  session_id,
  user_id,
  user_ns,
  payload,
  is_bot,
  is_llm,
  ai_input_tokens,
  ai_output_tokens,
  ai_params,
  num_que_asked,
  info_collection_end,
  next_payload,
  next_date,
  next_time
FROM NextUserEntries
WHERE payload LIKE "%Now, where would you like to go for the vacation?%"










-- Answers for Destination.

WITH NextUserEntries AS (
  SELECT
    *,
    -- Use LEAD to look ahead at the next payload
    LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
    -- Additionally, get the next row's basic conversation details for context
    LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
    LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
)
-- Now we filter rows where the payload contains the specific substring we're interested in.
SELECT
  date,
  time,
  session_id,
  user_id,
  user_ns,
  payload,
  is_bot,
  is_llm,
  ai_input_tokens,
  ai_output_tokens,
  ai_params,
  num_que_asked,
  info_collection_end,
  next_payload,
  next_date,
  next_time
FROM NextUserEntries
WHERE payload LIKE "%Now, where would you like to go for the vacation?%"










-- Answers for Check In & Check Out.

WITH NextUserEntries AS (
  SELECT
    *,
    -- Use LEAD to look ahead at the next payload
    LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
    -- Additionally, get the next row's basic conversation details for context
    LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
    LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
)
-- Now we filter rows where the payload contains the specific substring we're interested in.
SELECT
  date,
  time,
  session_id,
  user_id,
  user_ns,
  payload,
  is_bot,
  is_llm,
  ai_input_tokens,
  ai_output_tokens,
  ai_params,
  num_que_asked,
  info_collection_end,
  next_payload,
  next_date,
  next_time
FROM NextUserEntries
WHERE payload LIKE "%Now, I need to know your check-in and check-out dates.%"







-- Answers for Occupants.

WITH NextUserEntries AS (
  SELECT
    *,
    -- Use LEAD to look ahead at the next payload
    LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
    -- Additionally, get the next row's basic conversation details for context
    LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
    LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
)
-- Now we filter rows where the payload contains the specific substring we're interested in.
SELECT
  date,
  time,
  session_id,
  user_id,
  user_ns,
  payload,
  is_bot,
  is_llm,
  ai_input_tokens,
  ai_output_tokens,
  ai_params,
  num_que_asked,
  info_collection_end,
  next_payload,
  next_date,
  next_time
FROM NextUserEntries
WHERE payload LIKE "%total number of adults (above the age of 5)%"







-- Answers for confirmation.

WITH NextUserEntries AS (
  SELECT
    *,
    -- Use LEAD to look ahead at the next payload
    LEAD(payload) OVER(PARTITION BY user_id ORDER BY date, time) AS next_payload,
    -- Additionally, get the next row's basic conversation details for context
    LEAD(date) OVER(PARTITION BY user_id ORDER BY date, time) AS next_date,
    LEAD(time) OVER(PARTITION BY user_id ORDER BY date, time) AS next_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
)
-- Now we filter rows where the payload contains the specific substring we're interested in.
SELECT
  date,
  time,
  session_id,
  user_id,
  user_ns,
  payload,
  is_bot,
  is_llm,
  ai_input_tokens,
  ai_output_tokens,
  ai_params,
  num_que_asked,
  info_collection_end,
  next_payload,
  next_date,
  next_time
FROM NextUserEntries
WHERE payload LIKE "%Please confirm if everything looks good.%"




--- Average time total
WITH SessionTimes AS (
  SELECT
    session_id,
    -- Convert date and time into a single timestamp
    MIN(TIMESTAMP(CONCAT(date, ' ', time))) AS start_time,
    MAX(TIMESTAMP(CONCAT(date, ' ', time))) AS end_time
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  GROUP BY
    session_id
),
SessionDurations AS (
  SELECT
    session_id,
    -- Calculate the duration of each session in minutes
    TIMESTAMP_DIFF(end_time, start_time, MINUTE) AS duration_minutes
  FROM
    SessionTimes
)

-- Finally, compute the average session duration across all sessions
SELECT
  AVG(duration_minutes) AS average_chat_time_minutes
FROM
  SessionDurations



-- Average time 
WITH SessionBoundaries AS (
  SELECT
    session_id,
    -- Assuming CONCAT() forms a proper timestamp string; adjust if the format is different.
    MIN(TIMESTAMP(CONCAT(date, ' ', time))) AS session_start,
    MAX(TIMESTAMP(CONCAT(date, ' ', time))) AS session_end
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  GROUP BY
    session_id
)

-- Compute session durations and then the average duration for each session
SELECT
  session_id,
  -- Calculate each session's duration in desired unit, e.g., minutes
  TIMESTAMP_DIFF(session_end, session_start, MINUTE) AS session_duration_minutes
FROM
  SessionBoundaries



--Avg time 2 with:
-- session_id
-- start_date
-- start_time
-- end_date
-- end_time
-- session_duration_minutes

WITH SessionBoundaries AS (
  SELECT
    session_id,
    MIN(TIMESTAMP(CONCAT(date, ' ', time))) AS session_start,
    MAX(TIMESTAMP(CONCAT(date, ' ', time))) AS session_end
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  GROUP BY
    session_id
)

SELECT
  session_id,
  -- Extract start date and time
  EXTRACT(DATE FROM session_start) AS start_date,
  EXTRACT(TIME FROM session_start) AS start_time,
  -- Extract end date and time
  EXTRACT(DATE FROM session_end) AS end_date,
  EXTRACT(TIME FROM session_end) AS end_time,
  -- Calculate session's duration in minutes
  TIMESTAMP_DIFF(session_end, session_start, MINUTE) AS session_duration_minutes
FROM
  SessionBoundaries









-- Average response time between user and bot per session.
WITH TimedMessages AS (
  SELECT
    session_id,
    is_bot,
    -- Combine the date and time into a single timestamp for each message
    TIMESTAMP(CONCAT(date, ' ', time)) AS message_timestamp,
    -- Use LAG() to get the timestamp of the previous message in the same session
    LAG(TIMESTAMP(CONCAT(date, ' ', time))) OVER(PARTITION BY session_id ORDER BY date, time) AS prev_message_timestamp
  FROM
    `test-project-122123.elivaas_db.conversation_data`
),

ResponseTimes AS (
  SELECT
    session_id,
    is_bot,
    message_timestamp,
    prev_message_timestamp,
    -- Calculate the time difference between the current message and the previous one in seconds
    TIMESTAMP_DIFF(message_timestamp, prev_message_timestamp, SECOND) AS response_time_seconds
  FROM
    TimedMessages
  WHERE
    prev_message_timestamp IS NOT NULL -- Exclude the first message of each session as it has no preceding message
)

SELECT
  session_id,
  -- Calculate the average response time for each session
  AVG(response_time_seconds) AS avg_response_time_seconds
FROM
  ResponseTimes
GROUP BY
  session_id




-- Avg of all 
WITH TimedMessages AS (
  SELECT
    session_id,
    is_bot,
    -- Combine the date and time into a single timestamp for each message
    TIMESTAMP(CONCAT(date, ' ', time)) AS message_timestamp,
    -- Use LAG() to get the timestamp of the previous message in the same session
    LAG(TIMESTAMP(CONCAT(date, ' ', time))) OVER(PARTITION BY session_id ORDER BY date, time) AS prev_message_timestamp
  FROM
    `test-project-122123.elivaas_db.conversation_data`
),

ResponseTimes AS (
  SELECT
    session_id,
    is_bot,
    message_timestamp,
    prev_message_timestamp,
    -- Calculate the time difference between the current message and the previous one in seconds
    TIMESTAMP_DIFF(message_timestamp, prev_message_timestamp, SECOND) AS response_time_seconds
  FROM
    TimedMessages
  WHERE
    prev_message_timestamp IS NOT NULL -- Exclude the first message of each session as it has no preceding message
)

-- Calculate the overall average response time across all sessions
SELECT
  AVG(response_time_seconds) AS overall_avg_response_time_seconds
FROM
  ResponseTimes


--response time in relation w length of payload 
WITH MessagesWithLength AS (
  SELECT
    session_id,
    is_bot,
    payload,
    -- Calculate the character length of each payload
    LENGTH(payload) AS text_length,
    -- Combine the date and time into a single timestamp for each message
    TIMESTAMP(CONCAT(date, ' ', time)) AS message_timestamp,
    -- Use LEAD to get the timestamp of the next message by a bot in the session
    LEAD(TIMESTAMP(CONCAT(date, ' ', time))) OVER(PARTITION BY session_id ORDER BY date, time) AS next_bot_message_timestamp
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  WHERE
    is_bot = 'no' -- Filter for user messages
),

ResponseTimes AS (
  SELECT
    session_id,
    text_length,
    -- Calculate the time difference (in seconds) to the next bot message
    TIMESTAMP_DIFF(next_bot_message_timestamp, message_timestamp, SECOND) AS response_time_seconds
  FROM
    MessagesWithLength
  WHERE
    next_bot_message_timestamp IS NOT NULL -- Exclude messages without a following bot response
)

-- Aggregate data to explore the relationship between message text length and bot response time
SELECT
  text_length,
  AVG(response_time_seconds) AS avg_response_time_seconds
FROM
  ResponseTimes
GROUP BY
  text_length
ORDER BY
  text_length













WITH UserMessages AS (
  SELECT
    session_id,
    -- Combine the date and time into a single timestamp for each message
    TIMESTAMP(CONCAT(date, ' ', time)) AS user_message_timestamp,
    -- Calculate the length of user's message payload
    LENGTH(payload) AS user_payload_length,
    -- Row number for each user message within each session
    ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY TIMESTAMP(CONCAT(date, ' ', time))) as user_msg_row_num
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  WHERE
    is_bot = 'no' -- Filter for messages sent by the user
),

BotResponses AS (
  SELECT
    session_id,
    -- Create a timestamp for each bot message
    TIMESTAMP(CONCAT(date, ' ', time)) AS bot_response_timestamp,
    -- Row number for each bot message within each session,
    -- effectively to match each bot message to the preceding user message
    ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY TIMESTAMP(CONCAT(date, ' ', time))) as bot_msg_row_num
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  WHERE
    is_bot = 'yes' -- Filter for messages sent by the bot
),

-- Join user messages with bot responses based on their sequential order in the same session
MatchedMessages AS (
  SELECT
    UM.session_id,
    UM.user_payload_length,
    UM.user_message_timestamp,
    BR.bot_response_timestamp
  FROM
    UserMessages UM
  JOIN
    BotResponses BR
  ON
    UM.session_id = BR.session_id
    AND UM.user_msg_row_num = BR.bot_msg_row_num -- Match based on row number to ensure order
),

-- Calculate response times for matched messages
ResponseTimes AS (
  SELECT
    user_payload_length,
    -- Calculate the difference in seconds between user message and bot response
    TIMESTAMP_DIFF(bot_response_timestamp, user_message_timestamp, SECOND) AS response_time_seconds
  FROM
    MatchedMessages
)

-- Aggregate to find average response times based on user message length
SELECT
  user_payload_length,
  AVG(response_time_seconds) AS avg_response_time_seconds
FROM
  ResponseTimes
GROUP BY
  user_payload_length
ORDER BY
  user_payload_length

--Author: Kevin Antony
--Created On: 21.02.24
--Code Stored on: 


--HT
WITH UserQuestions AS (
  SELECT
  user_id,
    payload
  -- FROM
  --   `test-project-122123.elivaas_db.conversation_data`
FROM `test-project-122123.holiday_tribe_db.conversation_data` 
  WHERE
    is_bot = 'no'
    AND REGEXP_CONTAINS(payload, r'\?')
    AND NOT (
      REGEXP_CONTAINS(LOWER(payload), r'\bperfect\b')
      AND REGEXP_CONTAINS(LOWER(payload), r'\bvacation\b')
    ) -- Excludes payloads containing both "perfect" and "vacation" anywhere in the text.
    
)

SELECT DISTINCT user_id,
  payload AS Question
FROM
  UserQuestions




--Elivaas
WITH UserQuestions AS (
  SELECT
  user_id,
    payload
  FROM
    `test-project-122123.elivaas_db.conversation_data`
  WHERE
    is_bot = 'No'
    AND REGEXP_CONTAINS(payload, r'\?')
)

SELECT DISTINCT user_id,
  payload AS Question
FROM
  UserQuestions

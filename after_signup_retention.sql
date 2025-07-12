-- 유저별 최초 가입일
WITH signup_events AS (
  SELECT
    user_id,
    DATE(MIN(event_time_seoul)) AS signup_date
  FROM `codeit.complete_signup`
  WHERE DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
  GROUP BY user_id
)

-- 전체 활동 로그 중, 활동 날짜만 추출
,activity_logs AS (
  SELECT
    user_id,
    DATE(event_time_seoul) AS activity_date
  FROM `codeit.time_id_event_all`
  WHERE DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
)

-- 가입일과 활동일을 user_id 기준으로 join
-- 가입일 기준 몇 주 뒤에 활동했는지 week_number 계산
-- 단, 가입 후 최대 180일 이내의 활동만 포함
,joined_logs AS (
  SELECT
    s.signup_date,
    a.activity_date,
    s.user_id,
    DATE_DIFF(a.activity_date, s.signup_date, WEEK) AS week_number
  FROM signup_events s
  JOIN activity_logs a ON s.user_id = a.user_id
  WHERE DATE_DIFF(a.activity_date, s.signup_date, DAY) BETWEEN 0 AND 180
)

-- 전체 cohort base user 수
,base_user_count AS (
  SELECT COUNT(DISTINCT user_id) AS base_users
  FROM signup_events
)

-- 각 주차별 활동한 유저 수 계산
-- base 가입수 대비 리텐션율 계산
SELECT
  j.week_number,
  b.base_users,
  COUNT(DISTINCT j.user_id) AS retained_users,
  ROUND(COUNT(DISTINCT j.user_id) * 1.0 / b.base_users, 4) AS retention_rate
FROM joined_logs j
CROSS JOIN base_user_count b
GROUP BY j.week_number, b.base_users
ORDER BY j.week_number;

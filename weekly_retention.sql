-- weekly retention (전체)

WITH base AS (
  SELECT
    DISTINCT
      user_id,
      event_type,
      event_time_seoul,
  FROM `time_id_event_all`
  WHERE
    event_time_seoul BETWEEN '2023-07-01' AND '2023-12-31'
)

-- 첫 방문 주차 기준, 각 유저의 이벤트 주차 차이 계산
,first_week_and_diff AS (
  SELECT
    *,
    DATE_DIFF(event_week, first_week, WEEK) AS diff_of_week
  FROM (
    SELECT
      DISTINCT
        user_id,
        DATE(DATE_TRUNC(MIN(event_time_seoul) OVER(PARTITION BY user_id), WEEK(MONDAY))) AS first_week,
        DATE(DATE_TRUNC(event_time_seoul, WEEK(MONDAY))) AS event_week,
        DATE(event_time_seoul) event_date
    FROM base
  )
)

-- 주차별 고유 유저 수 집계 (각 주차별 몇명의 유저들이 방문했는지)
, user_counts AS (
  SELECT
    diff_of_week,
    COUNT(DISTINCT user_id) AS user_cnt
  FROM first_week_and_diff
  GROUP BY diff_of_week
)

-- 주차별 리텐션(rate) 계산
SELECT
  *,
  ROUND(SAFE_DIVIDE(user_cnt, first_week_user_cnt), 2) AS retention_rate
FROM (
  SELECT
    diff_of_week,
    user_cnt,
    FIRST_VALUE(user_cnt) OVER(ORDER BY diff_of_week ASC) AS first_week_user_cnt
  FROM user_counts
)














-- 첫 콘텐츠 시청 이후 몇칠 째 되는 날까지 활동한 기록이 있는지
-- 가장 마지막 활동일이 몇일째인지 파악 -> 유저가 언제 이탈했는지 간접 추정
WITH user_first_day AS (
  SELECT
    user_id,
    MIN(DATE(event_time_seoul)) AS first_day
  FROM `start_content`
  WHERE DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
  GROUP BY user_id
)

,user_activity_days AS (
  SELECT
    sc.user_id,
    DATE_DIFF(DATE(sc.event_time_seoul), ufd.first_day, DAY) AS day_diff
  FROM `start_content` sc
  JOIN user_first_day ufd
    ON sc.user_id = ufd.user_id
  WHERE DATE(sc.event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
    AND DATE_DIFF(DATE(sc.event_time_seoul), ufd.first_day, DAY) <= 7
)

-- SELECT * FROM user_activity_days

,user_last_day AS (
  SELECT
    user_id,
    MAX(day_diff) AS last_active_day
  FROM user_activity_days
  GROUP BY user_id
)

-- 마지막 활동일 분포 확인
SELECT
  last_active_day,
  COUNT(*) AS user_count
FROM user_last_day
GROUP BY last_active_day
ORDER BY last_active_day

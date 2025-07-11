-- user_id별 콘텐츠 클릭 횟수 집계
WITH content_cnt AS (
  SELECT
    user_id,
    COUNT(content_id) cnt
  FROM `start_content`
  WHERE
    DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
  GROUP BY user_id
  ORDER BY cnt DESC
)

-- 콘텐츠 클릭 전체 유저 수 26,088
,all_content_users AS (
  SELECT
    COUNT(DISTINCT user_id)
  FROM `start_content`
  WHERE
    DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
)

-- 콘텐츠 1회 클릭 유저 수 17552
,content_one_click AS (
  SELECT
    COUNT(*) cnt
  FROM content_cnt
  WHERE cnt = 1
)


SELECT * FROM content_one_click



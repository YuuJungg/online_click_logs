-- user_id별 레슨 클릭 횟수 집계
WITH lesson_cnt AS (
  SELECT
    user_id,
    COUNT(lesson_id) cnt
  FROM `codeit.enter_lesson`
  WHERE
    DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
  GROUP BY user_id
  ORDER BY cnt DESC
)

-- 레슨 횟수 최댓값 너무 커서 100개 이하로 필터링
,lesson_cnt_filtered AS (
  SELECT
    *
  FROM lesson_cnt
  WHERE cnt <= 100
)

-- 레슨 클릭 전체 유저 수 47,036
,all_lesson_users AS (
  SELECT
    COUNT(DISTINCT user_id) cnt
  FROM `codeit.enter_lesson`
  WHERE
    DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
)

-- 레슨 1회 클릭 유저 수 14,257
,content_one_click AS (
  SELECT
    COUNT(*) cnt
  FROM lesson_cnt_filtered
  WHERE cnt = 1
)


SELECT * FROM content_one_click




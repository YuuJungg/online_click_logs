-- 핵심 클릭 이벤트 퍼널
-- funnel_number: 퍼널 순서

-- 핵심퍼널 (콘텐츠)
-- 사용한 테이블 complete.signup, start.content, end.content, complete.subscription
SELECT
  event_type,
  CASE
    WHEN event_type = 'complete.signup' THEN 1
    WHEN event_type = 'start.content' THEN 2
    WHEN event_type = 'end.content' THEN 3
    WHEN event_type = 'complete.subscription' THEN 4
  ELSE NULL
  END AS funnel_number,
  COUNT(DISTINCT user_id) AS cnt
FROM `time_id_event_all`
WHERE
  DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
GROUP BY ALL
HAVING funnel_number IS NOT NULL
ORDER BY funnel_number;

-- 핵심퍼널 (레슨)
SELECT
  event_type,
  CASE
    WHEN event_type = 'complete.signup' THEN 1
    WHEN event_type = 'enter.lesson_page' THEN 2
    WHEN event_type = 'complete.lesson' THEN 3
    WHEN event_type = 'complete.subscription' THEN 4
  ELSE NULL
  END AS funnel_number,
  COUNT(DISTINCT user_id) AS cnt
FROM `time_id_event_all`
WHERE
  DATE(event_time_seoul) BETWEEN '2023-07-01' AND '2023-12-31'
GROUP BY ALL
HAVING funnel_number IS NOT NULL
ORDER BY funnel_number;

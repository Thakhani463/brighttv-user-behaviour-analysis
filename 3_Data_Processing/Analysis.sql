SELECT
    -- ID
    A.UserID0 AS user_id,

    -- Date columns
    DATE(A.RecordDate2 + INTERVAL 2 HOURS) AS record_date,
    DAYOFWEEK(A.RecordDate2 + INTERVAL 2 HOURS) AS day_number,
    DATE_FORMAT(A.RecordDate2 + INTERVAL 2 HOURS, 'EEEE') AS day_name,
    MONTH(A.RecordDate2 + INTERVAL 2 HOURS) AS month_number,
    DATE_FORMAT(A.RecordDate2 + INTERVAL 2 HOURS, 'MMMM') AS month_name,
    DAY(A.RecordDate2 + INTERVAL 2 HOURS) AS day_of_month,

    -- Day classification
    CASE
        WHEN DAYOFWEEK(A.RecordDate2 + INTERVAL 2 HOURS) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    -- Time columns
    DATE_FORMAT(A.RecordDate2 + INTERVAL 2 HOURS, 'HH:mm:ss') AS record_time,
    HOUR(A.RecordDate2 + INTERVAL 2 HOURS) AS hour_number,
    DATE_FORMAT(A.RecordDate2 + INTERVAL 2 HOURS, 'hh a') AS hour_label,

    CASE
        WHEN HOUR(A.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 0 AND 11 THEN '01. Morning'
        WHEN HOUR(A.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 12 AND 16 THEN '02. Afternoon'
        WHEN HOUR(A.RecordDate2 + INTERVAL 2 HOURS) BETWEEN 17 AND 23 THEN '03. Evening'
    END AS time_bucket,

    -- User profile columns
    CASE
        WHEN B.Gender IS NULL THEN 'Unknown'
        WHEN TRIM(B.Gender) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(B.Gender)) = 'none' THEN 'Unknown'
        ELSE TRIM(B.Gender)
    END AS gender,

    CASE
        WHEN B.Province IS NULL THEN 'Unknown'
        WHEN TRIM(B.Province) = '' THEN 'Unknown'
        WHEN LOWER(TRIM(B.Province)) = 'none' THEN 'Unknown'
        ELSE TRIM(B.Province)
    END AS province,

    B.Age AS age,

    CASE
        WHEN B.Age IS NULL THEN 'Unknown'
        WHEN B.Age < 13 THEN '01. Children'
        WHEN B.Age BETWEEN 13 AND 19 THEN '02. Teenagers'
        WHEN B.Age BETWEEN 20 AND 34 THEN '03. Young Adults'
        WHEN B.Age BETWEEN 35 AND 54 THEN '04. Adults'
        ELSE '05. Seniors'
    END AS age,

    CASE
        WHEN B.Age IS NULL THEN 'Unknown'
        WHEN B.Age < 18 THEN '01. Under 18'
        WHEN B.Age BETWEEN 18 AND 24 THEN '02. 18-24'
        WHEN B.Age BETWEEN 25 AND 34 THEN '03. 25-34'
        WHEN B.Age BETWEEN 35 AND 44 THEN '04. 35-44'
        WHEN B.Age BETWEEN 45 AND 54 THEN '05. 45-54'
        ELSE '06. 55+'
    END AS age_bucket,

    -- Content columns
    CASE
        WHEN A.Channel2 IS NULL THEN 'Unknown Channel'
        WHEN TRIM(A.Channel2) = '' THEN 'Unknown Channel'
        WHEN LOWER(TRIM(A.Channel2)) = 'none' THEN 'Unknown Channel'
        ELSE TRIM(A.Channel2)
    END AS channel_group

FROM bright_tv.default.viewership AS A
LEFT JOIN bright_tv.default.user_profile AS B
    ON A.UserID0 = B.UserID;

CREATE MATERIALIZED VIEW installs_base_mv
REFRESH EVERY 5 SECOND
TO installs_base AS
SELECT 
    event_time AS install_time,
    store_id,
    event_id,
    ifa,
    oa_uid,
    client_ip,
    country_iso,
    event_uid,
    received_at
FROM 
(
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY oa_uid, ifa
            ORDER BY event_time ASC
        ) AS row_num
    FROM 
        events
    WHERE 
        event_id = 'app_open'
)
WHERE 
    row_num = 1;

use US_AQI_DDS
go

-- QS1-2
SELECT 
    s.state_name AS [State Name],
    d.Year AS [Year], 
    d.Quarter AS [Quarter],
    MIN(f.aqi_value) AS [MIN_AQI_VALUE],
    MAX(f.aqi_value) AS [MAX_AQI_VALUE],
    ROUND(AVG(f.aqi_value), 2) AS [AVG_AQI_VALUE],
    ROUND(STDEV(f.aqi_value), 2) AS [STD_AQI_VALUE]
FROM 
    FACT_AIR_QUALITY f
JOIN 
    dim_date d ON f.date_key = d.date_key
JOIN 
    dim_county c ON f.county_key = c.county_key
JOIN 
    dim_state s ON c.state_key = s.state_key
JOIN 
    dim_parameter p ON f.defining_parameter_key = p.parameter_key
GROUP BY 
    d.Year, d.Quarter, s.state_name
ORDER BY 
    s.state_name;
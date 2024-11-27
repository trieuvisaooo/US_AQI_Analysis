/***
* BI-CQ2021
* Group 2
* DDS Database
***/
USE MASTER
GO
--------------------------------------------------------------------------------------------------
-- Action: drop table when creating new database
IF DB_ID('US_AQI_DDS') IS NOT NULL DROP DATABASE US_AQI_DDS;

-- Action: create new database
CREATE DATABASE US_AQI_DDS COLLATE SQL_Latin1_General_CP1_CI_AS;
GO

USE US_AQI_DDS
GO
--------------------------------------------------------------------------------------------------
-- Action: drop table when creating new schema
-- Action: drop fk constraint before drop table
DECLARE @sql NVARCHAR(MAX);

-- Drop fk from FACT_AIR_QUALITY
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID(N'dbo.FACT_AIR_QUALITY'))
BEGIN
    SET @sql = (
        SELECT STRING_AGG('ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
                + ' DROP CONSTRAINT ' + QUOTENAME(name), '; ') 
        FROM sys.foreign_keys
        WHERE parent_object_id = OBJECT_ID(N'dbo.FACT_AIR_QUALITY')
    );
    EXEC sp_executesql @sql;
END;

-- Drop fk from DIM_COUNTY
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID(N'dbo.DIM_COUNTY'))
BEGIN
    SET @sql = (
        SELECT STRING_AGG('ALTER TABLE ' + QUOTENAME(OBJECT_NAME(parent_object_id)) 
                + ' DROP CONSTRAINT ' + QUOTENAME(name), '; ') 
        FROM sys.foreign_keys
        WHERE parent_object_id = OBJECT_ID(N'dbo.DIM_COUNTY')
    );
    EXEC sp_executesql @sql;
END;
-- Action: drop table
DROP TABLE IF EXISTS dbo.FACT_AIR_QUALITY;
DROP TABLE IF EXISTS dbo.DIM_DATE;
DROP TABLE IF EXISTS dbo.DIM_COUNTY;
DROP TABLE IF EXISTS dbo.DIM_STATE;
DROP TABLE IF EXISTS dbo.DIM_PARAMETER;
DROP TABLE IF EXISTS dbo.DIM_CATEGORY;


--------------------------------------------------------------------------------------------------
-- Action: create table for DDS
CREATE TABLE dbo.DIM_DATE (
    date_key INT PRIMARY KEY,
    date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    day INT NOT NULL,
    day_of_week INT NOT NULL,
    day_of_week_name VARCHAR(20) NOT NULL,
    day_light_saving BIT NOT NULL
);
GO

CREATE TABLE dbo.DIM_STATE (
	state_key INT PRIMARY KEY,
	state_id CHAR(2) UNIQUE,
	state_name VARCHAR(50)
);
GO

CREATE TABLE dbo.DIM_COUNTY (
	county_key INT PRIMARY KEY,
	county_fips CHAR(5),
	county_name VARCHAR(50),
	state_key INT,
	lat DECIMAL(9, 6),
	lng DECIMAL(9, 6),
	population INT,
	FOREIGN KEY (state_key) REFERENCES dbo.DIM_STATE(state_key)
);
GO

CREATE TABLE dbo.DIM_CATEGORY (
	category_key INT PRIMARY KEY,
	daily_aqi_color VARCHAR(10),
	level_of_concern VARCHAR(50),
	aqi_from INT,
	aqi_to INT,
	description VARCHAR(255)
);
GO

CREATE TABLE dbo.DIM_PARAMETER (
	parameter_key INT PRIMARY KEY,
	parameter_name VARCHAR(30)
);
GO

CREATE TABLE dbo.FACT_AIR_QUALITY (
	fact_air_quality_sk INT IDENTITY(1, 1) PRIMARY KEY,
	date_key INT,
	county_key INT,
	category_key INT,
	defining_parameter_key INT,
	aqi_value INT,
	defining_site VARCHAR(50),
	number_of_sites_report INT,
	FOREIGN KEY (date_key) REFERENCES dbo.DIM_DATE(date_key),
	FOREIGN KEY (county_key) REFERENCES dbo.DIM_COUNTY(county_key),
	FOREIGN KEY (category_key) REFERENCES dbo.DIM_CATEGORY(category_key),
	FOREIGN KEY (defining_parameter_key) REFERENCES dbo.DIM_PARAMETER(parameter_key)
);
GO
--------------------------------------------------------------------------------------------------
-- Action: insert data for DIM_DATE
WITH DateGenerator AS (
    SELECT CAST('2020-01-01' AS DATE) AS generated_date
    UNION ALL
    SELECT DATEADD(DAY, 1, generated_date)
    FROM DateGenerator
    WHERE generated_date < '2027-01-01'
)
INSERT INTO dbo.DIM_DATE
SELECT 
    CAST(FORMAT(generated_date, 'yyyyMMdd') AS INT) AS date_key,
    generated_date AS date,
    YEAR(generated_date) AS year,
    DATEPART(QUARTER, generated_date) AS quarter,
    MONTH(generated_date) AS month,
    DATENAME(MONTH, generated_date) AS month_name,
    DAY(generated_date) AS day,
    DATEPART(WEEKDAY, generated_date) AS day_of_week,
    DATENAME(WEEKDAY, generated_date) AS day_of_week_name,
    CASE 
        WHEN generated_date >= DATEADD(DAY, (14 - DATEPART(WEEKDAY, DATEFROMPARTS(YEAR(generated_date), 3, 1)) % 7), DATEFROMPARTS(YEAR(generated_date), 3, 1))
             AND generated_date < DATEADD(DAY, (7 - DATEPART(WEEKDAY, DATEFROMPARTS(YEAR(generated_date), 11, 1)) % 7), DATEFROMPARTS(YEAR(generated_date), 11, 1))
        THEN 1
        ELSE 0
    END AS day_light_saving
FROM DateGenerator
OPTION (MAXRECURSION 0);

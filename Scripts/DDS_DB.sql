USE MASTER
GO

IF DB_ID('US_AQI_DDS') IS NOT NULL DROP DATABASE US_AQI_DDS;

CREATE DATABASE US_AQI_DDS COLLATE SQL_Latin1_General_CP1_CI_AS;
GO

USE US_AQI_DDS
GO

DROP TABLE IF EXISTS dbo."fact_air_quality";
DROP TABLE IF EXISTS dbo."dim_date";
DROP TABLE IF EXISTS dbo."dim_county";
DROP TABLE IF EXISTS dbo."dim_parameter";
DROP TABLE IF EXISTS dbo."dim_category";
DROP TABLE IF EXISTS dbo."source";

CREATE TABLE dbo."source" (
	source_id INT PRIMARY KEY,
	source_name varchar(50),
	source_detail VARCHAR(255)
);
GO

CREATE TABLE dbo."dim_date" (
	date_id INT PRIMARY KEY,
	"date" DATE UNIQUE,
	"day" INT,
	"month" INT,
	"quarter" INT,
	"year" INT
);
GO

CREATE TABLE dbo."dim_state" (
	state_id INT PRIMARY KEY,
	state_code INT UNIQUE,
	state_name VARCHAR(50),
	source_id INT,

	FOREIGN KEY (source_id) REFERENCES dbo."source"(source_id)
);
GO

CREATE TABLE dbo."dim_county" (
	county_id INT PRIMARY KEY,
	county_code INT,
	county_name VARCHAR(50),
	state_id INT,
	lat FLOAT,
	lng FLOAT,
	"population" INT,
	source_id INT,

	FOREIGN KEY (source_id) REFERENCES dbo."source"(source_id),
	FOREIGN KEY (state_id) REFERENCES dbo."dim_state"(state_id)
);
GO

CREATE TABLE dbo."dim_category" (
	category_id INT PRIMARY KEY,
	daily_aqi_color VARCHAR(10),
	level_of_concern VARCHAR(50),
	aqi_from INT,
	aqi_to INT,
	description VARCHAR(255),
	source_id INT,

	FOREIGN KEY (source_id) REFERENCES dbo."source"(source_id)
);
GO

CREATE TABLE dbo."dim_parameter" (
	parameter_id INT PRIMARY KEY,
	parameter_name VARCHAR(30),
	source_id INT,

	FOREIGN KEY (source_id) REFERENCES dbo."source"(source_id)
);
GO

CREATE TABLE dbo."fact_air_quality" (
	date_id INT,
	county_id INT,
	category_id INT,
	defining_parameter_id INT,

	aqi_value INT,
	defining_site VARCHAR(50),
	number_of_sites_report INT,

	source_id INT,

	PRIMARY KEY (date_id, county_id, category_id, defining_parameter_id),
	FOREIGN KEY (date_id) REFERENCES dbo."dim_date"(date_id),
	FOREIGN KEY (county_id) REFERENCES dbo."dim_county"(county_id),
	FOREIGN KEY (category_id) REFERENCES dbo."dim_category"(category_id),
	FOREIGN KEY (defining_parameter_id) REFERENCES dbo."dim_parameter"(parameter_id),
	FOREIGN KEY (source_id) REFERENCES dbo."source"(source_id)
)
GO
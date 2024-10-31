/***
* BI-CQ2021
* Group 2
* Stage Database
***/
USE MASTER
GO

-- Action: drop table when creating new database
IF DB_ID('US_AQI_STAGE') IS NOT NULL DROP DATABASE US_AQI_STAGE;

CREATE DATABASE US_AQI_STAGE COLLATE SQL_Latin1_General_CP1_CI_AS;
GO


USE US_AQI_STAGE;
GO

-- Action: drop table when creating new schema
DROP TABLE IF EXISTS dbo."COUNTY_STAGE";
DROP TABLE IF EXISTS dbo."COUNTY_AQI_STAGE";
DROP TABLE IF EXISTS dbo."AQI_CATEGORY_STAGE";

-- Action: Create table per source system (csv only)
CREATE TABLE "COUNTY_STAGE" (
	"id"					  INT IDENTITY(1, 1),
	"county"                  VARCHAR(255),
	"county_ascii"            VARCHAR(255),
	"county_full"			  VARCHAR(255),
	"county_fips"			  INT,
	"state_id"				  VARCHAR(5),
	"state_name"			  VARCHAR(255),
	"lat"					  FLOAT,
	"lng"                     FLOAT,
	"population"			  INT
);
GO


CREATE TABLE "COUNTY_AQI_STAGE" (
	"id"					  INT IDENTITY(1, 1),
	"state_name"			  VARCHAR(255),
	"county_name"			  VARCHAR(255),
	"state_code"			  INT,
	"county_code"			  INT,
	"date"					  DATE,
	"aqi"					  INT,
	"category"				  VARCHAR(255),
	"defining_parameter"	  VARCHAR(255),
	"defining_site"			  VARCHAR(255),
	"number_of_sites_rep"	  INT,
	"created"				  DATETIME,
	"last_updated"			  DATETIME
);
GO

CREATE TABLE "AQI_CATEGORY_STAGE" (
	"id" INT IDENTITY(1, 1),
	aqi_color VARCHAR(10),
	level_of_concern VARCHAR(50),
	aqi_from INT,
	aqi_to INT,
	description_of_air_quality TEXT,
);
GO
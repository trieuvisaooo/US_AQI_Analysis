/***
* BI-CQ2021
* Group 2
* Description Schema for staging area
* Author: vanty
***/

CREATE DATABASE us_aqi_stage;
GO
USE us_aqi_stage;
GO

-- Action: drop table when creating new schema
DROP TABLE IF EXISTS dbo."state_aqi_stage_csv";
DROP TABLE IF EXISTS dbo."10_state_aqi_2021_csv";
DROP TABLE IF EXISTS dbo."10_state_aqi_2022_csv";
DROP TABLE IF EXISTS dbo."10_state_aqi_2023_csv";

-- Action: Create table per source system (csv only)

CREATE TABLE "state_aqi_stage_csv" (
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

CREATE TABLE "10_state_aqi_2021_csv" (
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

CREATE TABLE "10_state_aqi_2022_csv" (
	"state_name"			  VARCHAR(255),
	"county_name"			  VARCHAR(255),
	"state_code"			  INT,
	"county_code"			  INT,
	"date"				      DATE,
	"aqi"				      INT,
	"category"				  VARCHAR(255),
	"defining_parameter"	  VARCHAR(255),
	"defining_site"			  VARCHAR(255),
	"number_of_sites_rep"	  INT,
	"created"				  DATETIME,
	"last_updated"			  DATETIME
);
GO

CREATE TABLE "10_state_aqi_2023_csv" (
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
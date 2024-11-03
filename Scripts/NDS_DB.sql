/***
* BI-CQ2021
* Group 2
* NDS Database
***/
USE MASTER
GO

-- Action: drop table when creating new database
IF DB_ID('US_AQI_NDS') IS NOT NULL DROP DATABASE US_AQI_NDS;

CREATE DATABASE US_AQI_NDS COLLATE SQL_Latin1_General_CP1_CI_AS;
GO

USE US_AQI_NDS;
GO

-- Action: drop table when creating new schema
DROP TABLE IF EXISTS dbo.COUNTY_NDS;
DROP TABLE IF EXISTS dbo.STATE_NDS;
DROP TABLE IF EXISTS dbo.AQI_REPORT_NDS;
DROP TABLE IF EXISTS dbo.DEFINING_PARAMETER_NDS;
DROP TABLE IF EXISTS dbo.AQI_CATEGORY_NDS;


CREATE TABLE COUNTY_NDS (
	county_sk INT IDENTITY(1, 1), 
	county_code INT,
	county_name VARCHAR(50),
	county_fips VARCHAR(5),
	state_sk INT,
	lat FLOAT,
	lng FLOAT,
	population INT,
	source_id INT,

	CONSTRAINT pk_county_nds PRIMARY KEY(county_sk)
);
GO

CREATE TABLE STATE_NDS (
	state_sk INT IDENTITY(1, 1),
	state_id VARCHAR(2),
	state_code INT,
	state_name VARCHAR(50),
	source_id INT,

	CONSTRAINT pk_state_nds PRIMARY KEY(state_sk)
);
GO

CREATE TABLE AQI_REPORT_NDS (
	report_sk INT IDENTITY(1, 1),
	county_sk INT,
	date DATE,
	aqi_value INT, 
	category_sk INT,
	defining_parameter_sk INT,
	defining_site VARCHAR(30),
	num_of_site_reporting INT,
	source_id INT,
	created_date DATETIME,
	updated_date DATETIME,

	CONSTRAINT pk_report_nds PRIMARY KEY(report_sk)
);
GO

CREATE TABLE DEFINING_PARAMETER_NDS (
	parameter_sk INT IDENTITY(1, 1),
	parameter_name VARCHAR(30),
	
	CONSTRAINT pk_parameter_nds PRIMARY KEY(parameter_sk)
);
GO


CREATE TABLE AQI_CATEGORY_NDS (
	category_sk INT IDENTITY(1, 1),
	aqi_color VARCHAR(10),
	level_of_concern VARCHAR(50),
	aqi_from INT,
	aqi_to INT,
	description_of_air_quality VARCHAR(255),
	source_id INT,

	CONSTRAINT pk_category_nds PRIMARY KEY(category_sk)
);
GO


ALTER TABLE COUNTY_NDS 
ADD CONSTRAINT fk_county_state FOREIGN KEY (state_sk)
REFERENCES STATE_NDS (state_sk);
GO

ALTER TABLE AQI_REPORT_NDS
ADD CONSTRAINT fk_report_county FOREIGN KEY(county_sk)
REFERENCES COUNTY_NDS(county_sk);
GO

ALTER TABLE AQI_REPORT_NDS
ADD CONSTRAINT fk_report_category FOREIGN KEY(category_sk)
REFERENCES AQI_CATEGORY_NDS(category_sk);
GO

ALTER TABLE AQI_REPORT_NDS
ADD CONSTRAINT fk_report_parameter FOREIGN KEY(defining_parameter_sk)
REFERENCES DEFINING_PARAMETER_NDS(parameter_sk);
GO
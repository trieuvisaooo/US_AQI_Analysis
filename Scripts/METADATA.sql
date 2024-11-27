/***
* BI-CQ2021
* Group 2
* Metadata Database
***/
USE MASTER
GO

-- Action: drop table when creating new database
IF DB_ID('US_AQI_METADATA') IS NOT NULL DROP DATABASE US_AQI_METADATA;
GO

CREATE DATABASE US_AQI_METADATA COLLATE SQL_Latin1_General_CP1_CI_AS;
GO

USE US_AQI_METADATA;
GO

-- Action: drop table when creating new schema
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.fk_table_source'))
    ALTER TABLE dbo.TABLE_INFORMATION DROP CONSTRAINT fk_table_source;
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.fk_flow_status'))
    ALTER TABLE dbo.DATA_FLOW DROP CONSTRAINT fk_flow_status;

DROP TABLE IF EXISTS dbo.SOURCE_INFORMATION;
DROP TABLE IF EXISTS dbo.TABLE_INFORMATION;
DROP TABLE IF EXISTS dbo.DATA_FLOW;
DROP TABLE IF EXISTS dbo.DATA_FLOW_STATUS;
DROP TABLE IF EXISTS dbo.PACKAGE_INFORMATION;
DROP TABLE IF EXISTS dbo.EVENT_LOG;


CREATE TABLE SOURCE_INFORMATION (
    source_id INT PRIMARY KEY IDENTITY(1,1),
    source_name VARCHAR(255) NOT NULL UNIQUE,
    source_description NVARCHAR(1000)
);
GO

CREATE TABLE TABLE_INFORMATION (
    table_id INT PRIMARY KEY IDENTITY(1,1),
    table_name VARCHAR(255) NOT NULL,
    source_id INT,
    table_description NVARCHAR(1000)
);
GO

CREATE TABLE DATA_FLOW (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255) NOT NULL UNIQUE,
    description NVARCHAR(1000),
    source VARCHAR(255),              
    target VARCHAR(255),               
    status INT,
    lset DATETIME,                      
    cet DATETIME                        
);
GO

CREATE TABLE DATA_FLOW_STATUS (
    status_id INT PRIMARY KEY IDENTITY(1,1),
    status_name VARCHAR(50) NOT NULL
);
GO

CREATE TABLE PACKAGE_INFORMATION (
    package_id INT PRIMARY KEY IDENTITY(1,1),
    package_name VARCHAR(255) NOT NULL UNIQUE,
    package_description NVARCHAR(1000),
    package_schedule NVARCHAR(255)      
);
GO

CREATE TABLE EVENT_LOG (
    event_id INT PRIMARY KEY IDENTITY(1,1),
    event_name VARCHAR(255) NOT NULL,
    event_time DATETIME NOT NULL,
    event_error_msg NVARCHAR(1000)            
);
GO

DECLARE @lset DATETIME, @cet DATETIME
SET @lset = '2020-1-1 00:00:00'
SET @cet = '2020-1-2 00:00:00'

INSERT INTO DATA_FLOW (name, description, source, target, status, lset, cet) VALUES
('COUNTY_STAGE', 'ETL county table from source file (2B)uscounties.csv to county table on STAGE_DB', 'Source1', 'STAGE', 2, @LSET, @CET),
('COUNTY_AQI_STAGE', 'ETL county table from source files 10_state_aqi_*.csv to county_aqi table on STAGE_DB', 'Source1', 'STAGE', 2, @LSET, @CET),
('AQI_CATEGORY_STAGE', 'ETL county table from source file aqi_category.csv to aqi_category table on STAGE_DB', 'Source1', 'STAGE', 2, @LSET, @CET);

INSERT INTO DATA_FLOW_STATUS (status_name) VALUES ('In Progress');
INSERT INTO DATA_FLOW_STATUS (status_name) VALUES ('Completed');
INSERT INTO DATA_FLOW_STATUS (status_name) VALUES ('Failed');
INSERT INTO DATA_FLOW_STATUS (status_name) VALUES ('Cancelled');

INSERT INTO SOURCE_INFORMATION(source_name, source_description)  VALUES
('Source1', 'County information from (2B)uscounties.csv'),
('Source2', 'AQI report from csv files'),
('Source3', 'Category information');


ALTER TABLE TABLE_INFORMATION 
ADD CONSTRAINT fk_table_source FOREIGN KEY (source_id)
REFERENCES SOURCE_INFORMATION(source_id);

ALTER TABLE DATA_FLOW 
ADD CONSTRAINT fk_flow_status FOREIGN KEY (status)
REFERENCES DATA_FLOW_STATUS(status_id);

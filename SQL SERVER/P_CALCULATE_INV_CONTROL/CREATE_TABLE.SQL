-- TRSDB.dbo.TEMP_CALCULATE_INV_CONTROL1 definition

CREATE TABLE TRSDB.dbo.TEMP_CALCULATE_INV_CONTROL1 (
	ROUTES_ID varchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
	STARTING_ENTITY varchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	entity varchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	inv_entity varchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	ratio decimal(24,5) NULL,
	LEVELS int NULL,
	MAX_INV_LEVEL int NULL
);

-- TRSDB.dbo.TEMP_CALCULATE_INV_CONTROL2 definition


CREATE TABLE TRSDB.dbo.TEMP_CALCULATE_INV_CONTROL2 (
	ROUTES_ID varchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	STARTING_ENTITY varchar(50) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	ENTITY varchar(50) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	INV_ENTITY varchar(50) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	RATIO decimal(24,5) NULL,
	MULTIPLIER decimal(24,5) NULL,
	ACC_RATIO decimal(24,5) NULL,
	LEVELS int NULL,
	MAX_INV_LEVEL int NULL
);


-- TRSDB.dbo.TEMP_TRS_FACT_INV_CONTROL definition

CREATE TABLE TRSDB.dbo.TEMP_TRS_FACT_INV_CONTROL (
	ID varchar(36) COLLATE Chinese_Taiwan_Stroke_CI_AS NOT NULL,
	PERIOD date NULL,
	ENTITY_CODE nvarchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	INV_ENTITY_CODE nvarchar(255) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	UPDATED_TIME datetime NULL,
	RATIO_SUM decimal(24,5) NULL,
	RATIO_DIRECT decimal(24,5) NULL,
	RATIO_INDIRECT decimal(24,5) NULL
);
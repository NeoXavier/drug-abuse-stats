START TRANSACTION;

-- Importing AgeGroup dataset
LOAD DATA LOCAL INFILE 'data/DataonDrugAbusersArrestedByAgeGroup.csv' INTO TABLE DrugAbuseDB.TempTable
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(year, status, @age_group, no_of_drug_abusers) SET temp_var = @age_group;

-- Preprocessing of AgeGroup data as some statuses contain whitespace
UPDATE TempTable SET status = TRIM(status);

-- Populating the status tables
INSERT INTO Statuses (status) SELECT DISTINCT status FROM TempTable;

-- Populating the age group table
INSERT INTO AgeGroups (age_group) SELECT DISTINCT temp_var FROM TempTable;

ALTER TABLE DrugAbuseRecords ADD age_group TEXT;

-- Populate Drug Abuse Records
INSERT INTO DrugAbuseRecords (year, status_id, no_of_drug_abusers, age_group)
SELECT TempTable.year, Statuses.status_id, TempTable.no_of_drug_abusers, TempTable.temp_var
FROM TempTable
INNER JOIN Statuses ON TempTable.status = Statuses.status;

-- Add the mappings to the mapping table
INSERT INTO RecordAgeMapping (record_id, age_group_id)
SELECT dar.record_id, ag.age_group_id
FROM DrugAbuseRecords dar
INNER JOIN AgeGroups ag ON dar.age_group = ag.age_group;

-- Remove the age_group column
ALTER TABLE DrugAbuseRecords DROP COLUMN age_group;

-- Clear the Temp table
DELETE FROM TempTable;

COMMIT;

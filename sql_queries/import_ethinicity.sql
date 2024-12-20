START TRANSACTION;

-- Importing Ethnicity dataset
LOAD DATA LOCAL INFILE 'data/DataonDrugAbusersArrestedByEthnicGroup.csv' INTO TABLE DrugAbuseDB.TempTable
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(year, status, @ethnic_group, no_of_drug_abusers) SET temp_var = @ethnic_group;

-- Preprocessing of Ethnitcity data as some statuses contain whitespace
UPDATE TempTable SET status = TRIM(status);

-- Populating the age group table
INSERT INTO Ethnicity (ethnicity) SELECT DISTINCT temp_var FROM TempTable;

ALTER TABLE DrugAbuseRecords ADD ethnicity TEXT;

-- Populate Drug Abuse Records
INSERT INTO DrugAbuseRecords (year, status_id, no_of_drug_abusers, ethnicity)
SELECT TempTable.year, Statuses.status_id, TempTable.no_of_drug_abusers, TempTable.temp_var
FROM TempTable
INNER JOIN Statuses ON TempTable.status = Statuses.status;

-- Add the mappings to the mapping table
INSERT INTO RecordEthnicityMapping (record_id, ethnicity_id)
SELECT dar.record_id, e.ethnicity_id
FROM DrugAbuseRecords dar
INNER JOIN Ethnicity e ON dar.ethnicity = e.ethnicity;

ALTER TABLE DrugAbuseRecords DROP COLUMN ethnicity;

-- Clear the Temp table
DELETE FROM TempTable;

COMMIT;

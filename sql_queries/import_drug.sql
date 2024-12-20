START TRANSACTION;

-- Importing Drug dataset
LOAD DATA LOCAL INFILE 'data/DataonDrugAbusersArrestedByMainDrugAbused.csv' INTO TABLE DrugAbuseDB.TempTable
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(year, status, @drug_of_abuse, no_of_drug_abusers) SET temp_var = @drug_of_abuse;

-- Preprocessing of Drug data as some statuses contain whitespace
UPDATE TempTable SET status = TRIM(status);

-- Populating the age group table
INSERT INTO Drugs (drug_of_abuse) SELECT DISTINCT temp_var FROM TempTable;

ALTER TABLE DrugAbuseRecords ADD drug_of_abuse TEXT;

-- Populate Drug Abuse Records
INSERT INTO DrugAbuseRecords (year, status_id, no_of_drug_abusers, drug_of_abuse)
SELECT TempTable.year, Statuses.status_id, TempTable.no_of_drug_abusers, TempTable.temp_var
FROM TempTable
INNER JOIN Statuses ON TempTable.status = Statuses.status;

-- Add the mappings to the mapping table
INSERT INTO RecordDrugMapping (record_id, drug_id)
SELECT dar.record_id, d.drug_id
FROM DrugAbuseRecords dar
INNER JOIN Drugs d ON dar.drug_of_abuse = d.drug_of_abuse;

ALTER TABLE DrugAbuseRecords DROP COLUMN drug_of_abuse;

-- Clear the Temp table
DELETE FROM TempTable;

COMMIT;


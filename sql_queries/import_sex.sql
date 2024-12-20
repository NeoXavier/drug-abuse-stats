START TRANSACTION;

-- Importing Sex dataset
LOAD DATA LOCAL INFILE 'data/DataonDrugAbusersArrestedBySex.csv' INTO TABLE DrugAbuseDB.TempTable
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(year, status, @sex, no_of_drug_abusers) SET temp_var = @sex;

-- Preprocessing of Sex data as some statuses contain whitespace
UPDATE TempTable SET status = TRIM(status);

-- Populating the age group table
INSERT INTO Sex (sex) SELECT DISTINCT temp_var FROM TempTable;

ALTER TABLE DrugAbuseRecords ADD sex TEXT;

-- Populate Drug Abuse Records
INSERT INTO DrugAbuseRecords (year, status_id, no_of_drug_abusers, sex)
SELECT TempTable.year, Statuses.status_id, TempTable.no_of_drug_abusers, TempTable.temp_var
FROM TempTable
INNER JOIN Statuses ON TempTable.status = Statuses.status;


-- Add the mappings to the mapping table
INSERT INTO RecordSexMapping (record_id, sex_id)
SELECT dar.record_id, s.sex_id
FROM DrugAbuseRecords dar
INNER JOIN Sex s ON dar.sex = s.sex;

ALTER TABLE DrugAbuseRecords DROP COLUMN sex;

-- Clear the Temp table
DELETE FROM TempTable;

COMMIT;


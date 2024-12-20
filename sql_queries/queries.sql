-- Over the last 5 years, which age group has seen the steepest increase in drug abuse cases?
SELECT dar.year, a.age_group, dar.no_of_drug_abusers
FROM (
    SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
    FROM DrugAbuseRecords dar
    INNER JOIN Statuses s ON dar.status_id = s.status_id
    WHERE s.status = 'Total'
    AND dar.year >= 2019)
AS dar
INNER JOIN RecordAgeMapping ram ON dar.record_id = ram.record_id
INNER JOIN AgeGroups a ON ram.age_group_id = a.age_group_id;

-- What is the male-to-female ratio of drug abusers each year?
SELECT dar.year, s.sex, dar.no_of_drug_abusers
FROM (
    SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
    FROM DrugAbuseRecords dar
    INNER JOIN Statuses s ON dar.status_id = s.status_id
    WHERE s.status = 'Total')
AS dar
INNER JOIN RecordSexMapping rsm ON dar.record_id = rsm.record_id
INNER JOIN Sex s ON rsm.sex_id = s.sex_id;

-- Are certain ethnic groups more represented among new offenders?
SELECT dar.year, e.ethnicity, dar.no_of_drug_abusers, dar.status
FROM (
    SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
    FROM DrugAbuseRecords dar
    INNER JOIN Statuses s ON dar.status_id = s.status_id
    WHERE s.status = 'New')
AS dar
INNER JOIN RecordEthnicityMapping rem ON dar.record_id = rem.record_id
INNER JOIN Ethnicity e ON rem.ethnicity_id = e.ethnicity_id;

-- How has the use of specific drugs (e.g., Heroin, Cannabis) changed over time?
SELECT dar.year, d.drug_of_abuse, dar.no_of_drug_abusers
FROM (
    SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
    FROM DrugAbuseRecords dar
    INNER JOIN Statuses s ON dar.status_id = s.status_id
    WHERE s.status = 'Total')
AS dar
INNER JOIN RecordDrugMapping rdm ON dar.record_id = rdm.record_id
INNER JOIN Drugs d ON rdm.drug_id = d.drug_id;

-- What is the breakdown of drugs abused by new offenders? Is there a particular drug thats is more common for new drug abusers?
SELECT dar.year, d.drug_of_abuse, dar.no_of_drug_abusers, dar.status
FROM (
    SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
    FROM DrugAbuseRecords dar
    INNER JOIN Statuses s ON dar.status_id = s.status_id
    WHERE s.status = 'New')
AS dar
INNER JOIN RecordDrugMapping rdm ON dar.record_id = rdm.record_id
INNER JOIN Drugs d ON rdm.drug_id = d.drug_id;


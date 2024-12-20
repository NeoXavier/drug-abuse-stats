-- Temp table for data imports
CREATE TABLE TempTable (
    id INT PRIMARY KEY AUTO_INCREMENT,
    year YEAR NOT NULL,
    status TEXT NOT NULL,
	temp_var TEXT NOT NULL,
    no_of_drug_abusers INT NOT NULL
);

-- Status Table
CREATE TABLE Statuses (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status TEXT NOT NULL
);

-- Central Table
CREATE TABLE DrugAbuseRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    year YEAR NOT NULL,
    status_id INT NOT NULL,
    no_of_drug_abusers INT NOT NULL,
    FOREIGN KEY (status_id) REFERENCES Statuses(status_id)
);

-- Dimension Tables
CREATE TABLE AgeGroups (
    age_group_id INT PRIMARY KEY AUTO_INCREMENT,
    age_group TEXT NOT NULL
);

CREATE TABLE Sex (
    sex_id INT PRIMARY KEY AUTO_INCREMENT,
    sex TEXT NOT NULL
);

CREATE TABLE Ethnicity (
    ethnicity_id INT PRIMARY KEY AUTO_INCREMENT,
    ethnicity TEXT NOT NULL
);

CREATE TABLE Drugs (
    drug_id INT PRIMARY KEY AUTO_INCREMENT,
    drug_of_abuse TEXT NOT NULL
);

-- Mapping Tables
CREATE TABLE RecordAgeMapping (
    record_id INT NOT NULL,
    age_group_id INT NOT NULL,
    PRIMARY KEY (record_id, age_group_id),
    FOREIGN KEY (record_id) REFERENCES DrugAbuseRecords(record_id),
    FOREIGN KEY (age_group_id) REFERENCES AgeGroups(age_group_id)
);

CREATE TABLE RecordSexMapping (
    record_id INT NOT NULL,
    sex_id INT NOT NULL,
    PRIMARY KEY (record_id, sex_id),
    FOREIGN KEY (record_id) REFERENCES DrugAbuseRecords(record_id),
    FOREIGN KEY (sex_id) REFERENCES Sex(sex_id)
);

CREATE TABLE RecordEthnicityMapping (
    record_id INT NOT NULL,
    ethnicity_id INT NOT NULL,
    PRIMARY KEY (record_id, ethnicity_id),
    FOREIGN KEY (record_id) REFERENCES DrugAbuseRecords(record_id),
    FOREIGN KEY (ethnicity_id) REFERENCES Ethnicity(ethnicity_id)
);

CREATE TABLE RecordDrugMapping (
    record_id INT NOT NULL,
    drug_id INT NOT NULL,
    PRIMARY KEY (record_id, drug_id),
    FOREIGN KEY (record_id) REFERENCES DrugAbuseRecords(record_id),
    FOREIGN KEY (drug_id) REFERENCES Drugs(drug_id)
);


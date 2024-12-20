const Chart = require('chart.js/auto');
const express = require('express');
const mysql = require('mysql');
const app = express();
const PORT = 3000;


// MySQL connection configuration
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'DrugAbuseDB'
});

app.set("views", __dirname + "/views");
app.set("view engine", "ejs"); // set the app to use ejs for rendering
app.use(express.static(__dirname + "/public"));

// Connect to the database
db.connect(err => {
    if (err) {
        console.error('Error connecting to the database:', err);
        process.exit(1);
    }
    console.log('Connected to the database');
});

app.get('/', (req, res) => {
    res.render('main');
});

app.get('/q1', (req, res) => {
    const query = `
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
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            res.status(500).json({ error: 'Database query failed' });
        } else {
            // res.json(results);
            res.render('q1', { results });
        }
    });
});

app.get('/q2', (req, res) => {
    const query = `
        SELECT dar.year, s.sex, dar.no_of_drug_abusers
        FROM (
            SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
            FROM DrugAbuseRecords dar
            INNER JOIN Statuses s ON dar.status_id = s.status_id
            WHERE s.status = 'Total')
        AS dar
        INNER JOIN RecordSexMapping rsm ON dar.record_id = rsm.record_id
        INNER JOIN Sex s ON rsm.sex_id = s.sex_id;
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            res.status(500).json({ error: 'Database query failed' });
        } else {
            // res.json(results);
            res.render('q2', { results });
        }
    });
});

app.get('/q3', (req, res) => {
    const query = `
        SELECT dar.year, e.ethnicity, dar.no_of_drug_abusers, dar.status
        FROM (
            SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
            FROM DrugAbuseRecords dar
            INNER JOIN Statuses s ON dar.status_id = s.status_id
            WHERE s.status = 'New')
        AS dar
        INNER JOIN RecordEthnicityMapping rem ON dar.record_id = rem.record_id
        INNER JOIN Ethnicity e ON rem.ethnicity_id = e.ethnicity_id;
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            res.status(500).json({ error: 'Database query failed' });
        } else {
            // res.json(results);
            res.render('q3', { results });
        }
    });
});

app.get('/q4', (req, res) => {
    const query = `
        SELECT dar.year, d.drug_of_abuse, dar.no_of_drug_abusers
        FROM (
            SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
            FROM DrugAbuseRecords dar
            INNER JOIN Statuses s ON dar.status_id = s.status_id
            WHERE s.status = 'Total')
        AS dar
        INNER JOIN RecordDrugMapping rdm ON dar.record_id = rdm.record_id
        INNER JOIN Drugs d ON rdm.drug_id = d.drug_id;
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            res.status(500).json({ error: 'Database query failed' });
        } else {
            // res.json(results);
            res.render('q4', { results });
        }
    });
});

app.get('/q5', (req, res) => {
    const query = `
        SELECT dar.year, d.drug_of_abuse, dar.no_of_drug_abusers, dar.status
        FROM (
            SELECT dar.record_id, dar.year, s.status, dar.no_of_drug_abusers
            FROM DrugAbuseRecords dar
            INNER JOIN Statuses s ON dar.status_id = s.status_id
            WHERE s.status = 'New')
        AS dar
        INNER JOIN RecordDrugMapping rdm ON dar.record_id = rdm.record_id
        INNER JOIN Drugs d ON rdm.drug_id = d.drug_id;
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error executing query:', err);
            res.status(500).json({ error: 'Database query failed' });
        } else {
            // res.json(results);
            res.render('q5', { results });
        }
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});

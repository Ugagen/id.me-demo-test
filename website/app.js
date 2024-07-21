const register = require('prom-client').register;
const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 80;
// Get PostgreSQL connection details from environment variables
const pool = new Pool({
  user: process.env.PGUSER,
  host: process.env.PGHOST, 
  database: process.env.PGDATABASE,
  password: process.env.PGPASSWORD,
  port: process.env.PGPORT, // PostgreSQL port (default 5432)
});

app.get('/', (req, res) => {
  pool
    .query('SELECT message FROM greetings')
    .then(result => {
      res.send(result.rows[0].message);
    })
    .catch(err => {
      console.error('Error executing query', err.stack);
      res.status(500).send('Error retrieving message from database');
    });
});

app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
  } catch (err) {
    res.status(500).end(err);
  }
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});

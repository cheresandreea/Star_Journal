const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bodyParser = require('body-parser');
const cors = require('cors');

// Initialize Express app
const app = express();
const port = 3000;

// Middleware
app.use(cors({
  origin: '*', // Allow all origins (for debugging, refine it for production)
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));
app.use(bodyParser.json());

// Initialize SQLite database
const db = new sqlite3.Database('E:\\sqlite\\gui\\databases\\starJournal.db', (err) => {
  if (err) {
    console.error("Error opening database:", err);
  } else {
    console.log("Connected to SQLite database.");
  }
});

// Create table (if it doesn't exist)
db.run(`
  CREATE TABLE IF NOT EXISTS Star (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    radius REAL,
    xPosition REAL,
    yPosition REAL,
    temperature INTEGER,
    galaxy TEXT,
    constellation TEXT,
    description TEXT
  )
`);

// GET all stars
app.get('/stars', (req, res) => {
  db.all('SELECT * FROM Star', [], (err, rows) => {
    if (err) {
      res.status(500).send(err.message);
    } else {
      res.json(rows);
    }
  });
});

// GET star by ID
app.get('/stars/:id', (req, res) => {
  const { id } = req.params;
  db.get('SELECT * FROM Star WHERE id = ?', [id], (err, row) => {
    if (err) {
      res.status(500).send(err.message);
    } else {
      res.json(row || null);
    }
  });
});

// POST (Create) a new star
app.post('/stars', (req, res) => {
  const { name, radius, xPosition, yPosition, temperature, galaxy, constellation, description} = req.body;
  const query = `
    INSERT INTO Star (name, radius, xPosition, yPosition, temperature, galaxy, constellation, description)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  
  db.run(query, [name, radius, xPosition, yPosition, temperature, galaxy, constellation, description], function(err) {
    if (err) {
      res.status(500).send(err.message); // Internal server error
    } else {
      // Send a 201 status with the created resource's ID and the full details of the new star
      res.status(201).json({
        id: this.lastID, // The ID of the new star
        name,
        radius,
        xPosition,
        yPosition,
        temperature,
        galaxy,
        constellation,
        description
      });
    }
  });
});

// PUT (Update) an existing star
app.put('/stars/:id', (req, res) => {
  const { id } = req.params;
  const { name, radius, xPosition, yPosition, temperature, galaxy, constellation, description } = req.body;

  const query = `
    UPDATE Star
    SET name = ?, radius = ?, xPosition = ?, yPosition = ?, temperature = ?, galaxy = ?, constellation = ?, description = ?
    WHERE id = ?
  `;

  db.run(query, [name, radius, xPosition, yPosition, temperature, galaxy, constellation, description, id], function(err) {
    if (err) {
      res.status(500).send(err.message); // Internal server error
    } else if (this.changes === 0) {
      // If no rows were updated, it means the star with the given ID doesn't exist
      res.status(404).send('Star not found');
    } else {
      // Send a 200 OK status and return the updated star data
      res.status(200).json({
        id,
        name,
        radius,
        xPosition,
        yPosition,
        temperature,
        galaxy,
        constellation,
        description
      });
    }
  });
});

// DELETE a star
app.delete('/stars/:id', (req, res) => {
  const { id } = req.params;
  db.run('DELETE FROM Star WHERE id = ?', [id], function(err) {
    if (err) {
      res.status(500).send(err.message);
    } else {
      res.status(204).send(); 
    }
  });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running at 192.168.1.252:${port}`);
});

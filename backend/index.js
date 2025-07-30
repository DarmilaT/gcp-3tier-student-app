const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

// Create DB connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
});

// Connect to DB
db.connect((err) => {
  if (err) {
    console.error("DB connection failed:", err);
    process.exit(1);
  }
  console.log("✅ MySQL Connected...");

  // Optional: test query after successful connection
  db.query("SELECT * FROM students", (err, results) => {
    if (err) {
      console.error("🔥 Test query failed:", err);
    } else {
      console.log("✅ Test query success. Found rows:", results.length);
    }
  });
});

// POST /students - add student
app.post("/students", (req, res) => {
  const { name, roll_number, class_name } = req.body;

  if (!name || !roll_number || !class_name) {
    return res.status(400).json({ error: "All fields are required" });
  }

  const sql =
    "INSERT INTO students (name, roll_number, class_name) VALUES (?, ?, ?)";
  db.query(sql, [name, roll_number, class_name], (err, result) => {
    if (err) return res.status(500).json({ error: "Failed to insert" });
    res.status(201).json({ message: "Student added", id: result.insertId });
  });
});

// GET /students - list students
app.get("/students", (req, res) => {
  db.query("SELECT * FROM students", (err, results) => {
    if (err) return res.status(500).json({ error: "Failed to fetch data" });
    res.json(results);
  });
});

// Start server
const PORT = process.env.PORT || 3500;
app.listen(PORT, () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);

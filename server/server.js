// Express API for the Travel Itinerary Database project
// Read-only reporting layer: GET-only routes, no auth, no write endpoints
// Wraps SQL queries from queries.sql and returns JSON for the frontend

require("dotenv").config();
const { types } = require("pg");
types.setTypeParser(1082, (val) => val); // keep DATE columns as plain 'YYYY-MM-DD' strings
const express = require("express");
const { Pool } = require("pg");

const app = express();
app.use(express.static('public'));
const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const PORT = process.env.PORT || 3000;

// GET /api/trips - all trips with derived status and total spend
app.get("/api/trips", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT trips.id, trips.name, trips.start_date, trips.end_date,
        CASE
          WHEN CURRENT_DATE < trips.start_date THEN 'planned'
          WHEN CURRENT_DATE BETWEEN trips.start_date AND trips.end_date THEN 'in-progress'
          ELSE 'completed'
        END AS status,
        COALESCE(SUM(expenses.amount_usd), 0) AS total_spend
      FROM trips
      LEFT JOIN destinations ON destinations.trip_id = trips.id
      LEFT JOIN expenses ON expenses.destination_id = destinations.id
      GROUP BY trips.id, trips.name, trips.start_date, trips.end_date
      ORDER BY trips.start_date;
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch trips" });
  }
});

// GET /api/trips/:id/destinations - a trip's destinations with per-destination spend
app.get("/api/trips/:id/destinations", async (req, res) => {
  try {
    const result = await pool.query(
      `
      SELECT destinations.id, destinations.name, destinations.arrival_date, destinations.departure_date,
        COALESCE(SUM(expenses.amount_usd), 0) AS total_spend
      FROM destinations
      LEFT JOIN expenses ON expenses.destination_id = destinations.id
      WHERE destinations.trip_id = $1
      GROUP BY destinations.id, destinations.name, destinations.arrival_date, destinations.departure_date
      ORDER BY destinations.arrival_date;
    `,
      [req.params.id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch destinations" });
  }
});

// GET /api/trips/:id/categories - spend-by-category breakdown for a trip
app.get("/api/trips/:id/categories", async (req, res) => {
  try {
    const result = await pool.query(
      `
      SELECT expenses.category, SUM(expenses.amount_usd) AS total_spend
      FROM expenses
      JOIN destinations ON destinations.id = expenses.destination_id
      WHERE destinations.trip_id = $1
      GROUP BY expenses.category
      ORDER BY total_spend DESC;
    `,
      [req.params.id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch category breakdown" });
  }
});

// GET /api/destinations/top-spend - the destination with the highest total spend overall
app.get("/api/destinations/top-spend", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT destinations.id, destinations.name, trips.name AS trip_name,
        COALESCE(SUM(expenses.amount_usd), 0) AS total_spend
      FROM destinations
      JOIN trips ON trips.id = destinations.trip_id
      LEFT JOIN expenses ON expenses.destination_id = destinations.id
      GROUP BY destinations.id, destinations.name, trips.name
      ORDER BY total_spend DESC
      LIMIT 1;
    `);
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch top-spending destination" });
  }
});

// GET /api/trips/:id/budget - budget vs actual spend for a trip (via trip_budget_summary view)
app.get("/api/trips/:id/budget", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT budget_amount, actual_spend, remaining FROM trip_budget_summary WHERE trip_id = $1;`,
      [req.params.id],
    );
    res.json(result.rows[0] || null);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch budget" });
  }
});

// GET /api/trips/:id/travelers - travelers on a trip
app.get("/api/trips/:id/travelers", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, name FROM travelers WHERE trip_id = $1 ORDER BY name;`,
      [req.params.id],
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch travelers" });
  }
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});

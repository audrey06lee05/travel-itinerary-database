-- Database schema: trips, destinations, expenses (one-to-many, cascading deletes)
-- Trip status is derived from dates at query time, not stored as a column
-- 3NF: no repeating groups, PK/FK/CHECK constraints enforce data integrity

CREATE TABLE trips (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  CHECK (end_date >= start_date)
);

CREATE TABLE destinations (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  name VARCHAR(150) NOT NULL,
  arrival_date DATE NOT NULL,
  departure_date DATE NOT NULL,
  CHECK (departure_date >= arrival_date)
);

CREATE TABLE expenses (
  id SERIAL PRIMARY KEY,
  destination_id INT NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  category VARCHAR(20) NOT NULL CHECK (category IN ('lodging', 'food', 'transport', 'activities', 'misc')),
  description VARCHAR(200),
  expense_date DATE NOT NULL,
  amount NUMERIC(10,2) NOT NULL CHECK (amount > 0),
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  exchange_rate NUMERIC(10,6) NOT NULL DEFAULT 1,
  amount_usd NUMERIC(10,2) NOT NULL CHECK (amount_usd > 0)
);

-- Stretch: travelers on a trip, and which travelers share which expenses
CREATE TABLE travelers (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE expense_travelers (
  expense_id INT NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
  traveler_id INT NOT NULL REFERENCES travelers(id) ON DELETE CASCADE,
  PRIMARY KEY (expense_id, traveler_id)
);

-- Stretch: budgets (optional, one per trip) and a view comparing budget vs actual spend
CREATE TABLE budgets (
  id SERIAL PRIMARY KEY,
  trip_id INT NOT NULL UNIQUE REFERENCES trips(id) ON DELETE CASCADE,
  budget_amount NUMERIC(10,2) NOT NULL CHECK (budget_amount > 0)
);

CREATE VIEW trip_budget_summary AS
SELECT
  trips.id AS trip_id,
  trips.name AS trip,
  budgets.budget_amount,
  COALESCE(SUM(expenses.amount_usd), 0) AS actual_spend,
  budgets.budget_amount - COALESCE(SUM(expenses.amount_usd), 0) AS remaining
FROM trips
LEFT JOIN budgets ON budgets.trip_id = trips.id
LEFT JOIN destinations ON destinations.trip_id = trips.id
LEFT JOIN expenses ON expenses.destination_id = destinations.id
GROUP BY trips.id, trips.name, budgets.budget_amount;

-- Query deliverables for the Travel Itinerary Database project
-- Organized by category: Filtering & Sorting, Aggregation, Joins, Subqueries
-- All amounts use amount_usd for cross-currency comparability

-- FILTERING & SORTING

-- Q1: All expenses over a given amount threshold, sorted by date descending
SELECT * FROM expenses
WHERE amount_usd > 100
ORDER BY expense_date DESC;

-- Q2: All destinations visited during a specific date range (overlap logic)
SELECT * FROM destinations
WHERE arrival_date <= '2026-03-16' AND departure_date >= '2026-03-14';

-- Q3: All trips currently "in-progress" based on today's date (status derived, not stored)
SELECT * FROM trips
WHERE CURRENT_DATE BETWEEN start_date AND end_date;


-- AGGREGATION

-- Q4: Total spend per trip
SELECT trips.name, COALESCE(SUM(expenses.amount_usd), 0) AS total_spend
FROM trips
LEFT JOIN destinations ON destinations.trip_id = trips.id
LEFT JOIN expenses ON expenses.destination_id = destinations.id
GROUP BY trips.id, trips.name;

-- Q5: Total spend per category, across all trips
SELECT category, SUM(amount_usd) AS total_spend
FROM expenses
GROUP BY category;

-- Q6: Average daily spend per destination (total expenses / nights stayed)
SELECT
  destinations.name,
  COALESCE(SUM(expenses.amount_usd), 0) AS total_spend,
  (destinations.departure_date - destinations.arrival_date) AS days,
  ROUND(COALESCE(SUM(expenses.amount_usd), 0) / (destinations.departure_date - destinations.arrival_date), 2) AS avg_daily_spend
FROM destinations
LEFT JOIN expenses ON expenses.destination_id = destinations.id
GROUP BY destinations.id, destinations.name, destinations.arrival_date, destinations.departure_date
ORDER BY avg_daily_spend DESC;

-- Q7: The destination with the highest total spend
SELECT destinations.name, COALESCE(SUM(expenses.amount_usd), 0) AS total_spend
FROM destinations
LEFT JOIN expenses ON expenses.destination_id = destinations.id
GROUP BY destinations.id, destinations.name
ORDER BY total_spend DESC
LIMIT 1;


-- JOINS

-- Q8: Every destination alongside its trip name and total expenses at that stop
SELECT destinations.name AS destination, trips.name AS trip, COALESCE(SUM(expenses.amount_usd), 0) AS total_expenses
FROM destinations
JOIN trips ON destinations.trip_id = trips.id
LEFT JOIN expenses ON expenses.destination_id = destinations.id
GROUP BY destinations.id, destinations.name, trips.name
ORDER BY trips.name, destinations.arrival_date;

-- Q9: Trips with more than one destination, with a count of destinations
SELECT trips.name, COUNT(destinations.id) AS destination_count
FROM trips
JOIN destinations ON destinations.trip_id = trips.id
GROUP BY trips.id, trips.name
HAVING COUNT(destinations.id) > 1
ORDER BY destination_count DESC;


-- SUBQUERIES

-- Q10: Destinations that spent above the overall average daily spend
SELECT dest_spend.name, dest_spend.avg_daily_spend
FROM (
  SELECT destinations.id, destinations.name,
    COALESCE(SUM(expenses.amount_usd), 0) / (destinations.departure_date - destinations.arrival_date) AS avg_daily_spend
  FROM destinations
  LEFT JOIN expenses ON expenses.destination_id = destinations.id
  GROUP BY destinations.id, destinations.name, destinations.arrival_date, destinations.departure_date
) AS dest_spend
WHERE dest_spend.avg_daily_spend > (
  SELECT AVG(sub.avg_daily_spend)
  FROM (
    SELECT COALESCE(SUM(expenses.amount_usd), 0) / (destinations.departure_date - destinations.arrival_date) AS avg_daily_spend
    FROM destinations
    LEFT JOIN expenses ON expenses.destination_id = destinations.id
    GROUP BY destinations.id, destinations.arrival_date, destinations.departure_date
  ) AS sub
)
ORDER BY dest_spend.avg_daily_spend DESC;

-- Q11: Trips where total spend exceeded a $2,000 budget threshold
SELECT trips.name, totals.total_spend
FROM trips
JOIN (
  SELECT destinations.trip_id, SUM(expenses.amount_usd) AS total_spend
  FROM destinations
  JOIN expenses ON expenses.destination_id = destinations.id
  GROUP BY destinations.trip_id
) AS totals ON totals.trip_id = trips.id
WHERE totals.total_spend > 2000
ORDER BY totals.total_spend DESC;

-- Q12: The most expensive single expense per trip (correlated subquery, no window functions)
SELECT trips.name AS trip, expenses.description, expenses.amount_usd
FROM expenses
JOIN destinations ON destinations.id = expenses.destination_id
JOIN trips ON trips.id = destinations.trip_id
WHERE expenses.amount_usd = (
  SELECT MAX(e2.amount_usd)
  FROM expenses e2
  JOIN destinations d2 ON d2.id = e2.destination_id
  WHERE d2.trip_id = trips.id
)
ORDER BY trips.name;

-- Stretch: split each shared expense evenly among the travelers on it
SELECT
  e.id AS expense_id,
  e.description,
  e.amount_usd,
  t.name AS traveler_name,
  ROUND(e.amount_usd / cnt.traveler_count, 2) AS share_amount
FROM expenses e
JOIN expense_travelers et ON et.expense_id = e.id
JOIN travelers t ON t.id = et.traveler_id
JOIN (
  SELECT expense_id, COUNT(*) AS traveler_count
  FROM expense_travelers
  GROUP BY expense_id
) cnt ON cnt.expense_id = e.id
ORDER BY e.id, t.name;

-- Stretch: the trip with the best "value" — lowest avg daily spend relative to destinations visited
SELECT
  trips.name AS trip,
  COALESCE(SUM(expenses.amount_usd), 0) AS total_spend,
  (trips.end_date - trips.start_date) AS trip_days,
  COUNT(DISTINCT destinations.id) AS destination_count,
  ROUND(COALESCE(SUM(expenses.amount_usd), 0) / (trips.end_date - trips.start_date), 2) AS avg_daily_spend,
  ROUND(
    (COALESCE(SUM(expenses.amount_usd), 0) / (trips.end_date - trips.start_date))
    / COUNT(DISTINCT destinations.id), 2
  ) AS value_score
FROM trips
JOIN destinations ON destinations.trip_id = trips.id
LEFT JOIN expenses ON expenses.destination_id = destinations.id
GROUP BY trips.id, trips.name, trips.start_date, trips.end_date
ORDER BY value_score ASC
LIMIT 1;

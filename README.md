# ✈️ Travel Itinerary Database
🧳 A normalized SQL database that models a traveler's trips, destinations, and expenses — with a minimal read-only Express API and a vanilla JS/HTML frontend on top.
Built as a bootcamp project focused on schema design, SQL querying, and wiring query results into a simple full-stack layer. No ORM, no frontend framework, no build tools.

## 🗣️ Language & Technologies
* PostgreSQL
* Node.js + Express
* `pg` (raw SQL, no ORM)
* HTML5 / CSS3 / vanilla JavaScript (`fetch`, no framework)

## 🗄️ Schema Design
* **Trips** — name, start date, end date. Status (planned/in-progress/completed) isn't a stored column — it's derived at query time from `CURRENT_DATE` against the trip's dates, so it can never go stale.
* **Destinations** — belong to exactly one trip (one-to-many), each with its own arrival/departure dates. A revisited place (e.g. stopping in Las Vegas twice on the same road trip) is just a second row, not a separate relationship type.
* **Expenses** — tied to a single destination, with category, amount, currency, and exchange rate. Stored in the original currency and converted to `amount_usd` via a fixed historical exchange rate, so cross-currency totals compare directly without converting at query time.
* **Travelers** *(stretch)* — scoped to a single trip, not tracked globally. `expense_travelers` is a many-to-many join table recording who shared an expense; the split itself isn't stored, it's computed at query time (`amount_usd / number of travelers on it`).
* **Budgets** *(stretch)* — optional, at most one per trip. The `trip_budget_summary` view left-joins budgets to trips so a trip without one still shows up, with a null budget/remaining.
<img width="994" height="767" alt="Screenshot 2026-09-01 at 11 24 52 pm" src="https://github.com/user-attachments/assets/83083055-71c4-44d9-8472-cfe18aff1e0c" />


## 🏗️ API Endpoints
All GET-only, no auth, raw SQL:

| Endpoint | Returns |
|---|---|
| `GET /api/trips` | All trips with derived status and total spend |
| `GET /api/trips/:id/destinations` | A trip's destinations with per-destination spend |
| `GET /api/trips/:id/categories` | Spend-by-category breakdown for a trip |
| `GET /api/trips/:id/budget` | Budget vs. actual spend for a trip |
| `GET /api/trips/:id/travelers` | Travelers on a trip |
| `GET /api/destinations/top-spend` | The single highest-spending destination overall |

## 🔧 Setup
1. Create a Postgres database (e.g. `travel_itinerary`)
2. Run `schema.sql` against it — creates the tables and the `trip_budget_summary` view
3. Run `seed_data.sql` — loads the sample trips, destinations, expenses, travelers, and budgets
4. Add a `.env` file in the project root:
   ```
   DATABASE_URL=postgresql://<user>:<password>@localhost:5432/travel_itinerary
   PORT=3000
   ```
5. `npm install`
6. `node server/server.js`
7. Open `http://localhost:3000`

## 📌 How to Use
#### 🧳 View Trips
The homepage lists every trip with its status badge (planned/in-progress/completed) and total spend.
#### 🔍 View Trip Details
Press **View Details** on any trip to see its destinations, category spend breakdown, travelers, and a budget status badge — green for under budget, red for over, gray if no budget's set.
#### 💰 Highest-Spending Destination
Press **Show Highest-Spending Destination** to see the single most expensive destination across all trips.

## 🗂️ Query Deliverables
`queries.sql` holds all 12 required query deliverables, organized by category (filtering & sorting, aggregation, joins, subqueries), plus the three stretch queries: splitting a shared expense evenly among travelers, finding the trip with the best "value" (lowest avg daily spend relative to destinations visited), and the budget-vs-actual view.

## 🌱 Sample Data
`seed_data.sql` covers 4 trips across USD, CHF, and JPY, plus the required edge cases: a single-destination trip (NYC), a zero-expense destination (Grand Canyon Village), and a trip with no budget set (also NYC).

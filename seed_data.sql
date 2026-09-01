-- Sample data: 4 trips, 11 destinations, 72 expenses
-- Currencies: USD, CHF, and JPY, converted to amount_usd via fixed exchange rates
-- Edge cases included: single-destination trip (NYC), zero-expense destination (Grand Canyon Village)

-- 1. Trips
INSERT INTO trips (name, start_date, end_date) VALUES
('US West Coast Road Trip', '2026-03-10', '2026-03-22'),
('Switzerland Winter Trip', '2026-12-15', '2026-12-24'),
('NYC Weekend Getaway', '2026-08-29', '2026-09-05'),
('Japan Spring Trip', '2026-04-05', '2026-04-16');

-- 2. Destinations
INSERT INTO destinations (trip_id, name, arrival_date, departure_date) VALUES
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'San Francisco, CA', '2026-03-10', '2026-03-12'),
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'Los Angeles, CA', '2026-03-12', '2026-03-15'),
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'Las Vegas, NV', '2026-03-15', '2026-03-18'),
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'Grand Canyon Village, AZ', '2026-03-18', '2026-03-20'),
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'Las Vegas, NV', '2026-03-20', '2026-03-22'),
((SELECT id FROM trips WHERE name = 'Switzerland Winter Trip'), 'Zurich', '2026-12-15', '2026-12-18'),
((SELECT id FROM trips WHERE name = 'Switzerland Winter Trip'), 'Lucerne', '2026-12-18', '2026-12-21'),
((SELECT id FROM trips WHERE name = 'Switzerland Winter Trip'), 'Interlaken', '2026-12-21', '2026-12-24'),
((SELECT id FROM trips WHERE name = 'NYC Weekend Getaway'), 'New York City, NY', '2026-08-29', '2026-09-05'),
((SELECT id FROM trips WHERE name = 'Japan Spring Trip'), 'Tokyo', '2026-04-05', '2026-04-09'),
((SELECT id FROM trips WHERE name = 'Japan Spring Trip'), 'Kyoto', '2026-04-09', '2026-04-13'),
((SELECT id FROM trips WHERE name = 'Japan Spring Trip'), 'Osaka', '2026-04-13', '2026-04-16');

-- 2b. Travelers (stretch goal: 2-3 per trip)
INSERT INTO travelers (trip_id, name) VALUES
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'Audrey'),
((SELECT id FROM trips WHERE name = 'US West Coast Road Trip'), 'Jamie'),
((SELECT id FROM trips WHERE name = 'Switzerland Winter Trip'), 'Audrey'),
((SELECT id FROM trips WHERE name = 'Switzerland Winter Trip'), 'Sam'),
((SELECT id FROM trips WHERE name = 'Switzerland Winter Trip'), 'Priya'),
((SELECT id FROM trips WHERE name = 'NYC Weekend Getaway'), 'Audrey'),
((SELECT id FROM trips WHERE name = 'Japan Spring Trip'), 'Audrey'),
((SELECT id FROM trips WHERE name = 'Japan Spring Trip'), 'Jamie');

-- 3. Expenses (Grand Canyon Village gets none — the zero-expense edge case)

-- San Francisco
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'San Francisco, CA'), 'lodging', 'Hotel Zephyr - 2 nights', '2026-03-10', 410.00, 'USD', 1, 410.00),
((SELECT id FROM destinations WHERE name = 'San Francisco, CA'), 'food', 'Dim sum brunch in Chinatown', '2026-03-10', 38.50, 'USD', 1, 38.50),
((SELECT id FROM destinations WHERE name = 'San Francisco, CA'), 'food', 'Dinner at Fisherman''s Wharf', '2026-03-11', 65.00, 'USD', 1, 65.00),
((SELECT id FROM destinations WHERE name = 'San Francisco, CA'), 'transport', 'BART day pass', '2026-03-11', 15.00, 'USD', 1, 15.00),
((SELECT id FROM destinations WHERE name = 'San Francisco, CA'), 'activities', 'Alcatraz ferry tour', '2026-03-11', 45.00, 'USD', 1, 45.00),
((SELECT id FROM destinations WHERE name = 'San Francisco, CA'), 'misc', 'Souvenir sweatshirt', '2026-03-12', 32.00, 'USD', 1, 32.00);

-- Los Angeles
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Los Angeles, CA'), 'lodging', 'Downtown LA hotel - 3 nights', '2026-03-12', 540.00, 'USD', 1, 540.00),
((SELECT id FROM destinations WHERE name = 'Los Angeles, CA'), 'transport', 'Rental car pickup', '2026-03-12', 120.00, 'USD', 1, 120.00),
((SELECT id FROM destinations WHERE name = 'Los Angeles, CA'), 'food', 'Tacos at Grand Central Market', '2026-03-13', 22.00, 'USD', 1, 22.00),
((SELECT id FROM destinations WHERE name = 'Los Angeles, CA'), 'activities', 'Universal Studios ticket', '2026-03-13', 135.00, 'USD', 1, 135.00),
((SELECT id FROM destinations WHERE name = 'Los Angeles, CA'), 'food', 'Dinner in Santa Monica', '2026-03-14', 78.00, 'USD', 1, 78.00),
((SELECT id FROM destinations WHERE name = 'Los Angeles, CA'), 'misc', 'Parking fees', '2026-03-14', 28.00, 'USD', 1, 28.00);

-- Las Vegas
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-15'), 'lodging', 'The LINQ Hotel - 3 nights', '2026-03-15', 360.00, 'USD', 1, 360.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-15'), 'transport', 'Gas fill-up', '2026-03-15', 48.00, 'USD', 1, 48.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-15'), 'food', 'Buffet at Bellagio', '2026-03-16', 55.00, 'USD', 1, 55.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-15'), 'activities', 'Cirque du Soleil tickets', '2026-03-16', 150.00, 'USD', 1, 150.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-15'), 'food', 'In-N-Out on the Strip', '2026-03-17', 18.00, 'USD', 1, 18.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-15'), 'misc', 'Casino chips (entertainment)', '2026-03-17', 60.00, 'USD', 1, 60.00);

-- Las Vegas (revisit, on the way back before flying home)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-20'), 'lodging', 'Excalibur Hotel - 2 nights', '2026-03-20', 220.00, 'USD', 1, 220.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-20'), 'food', 'Farewell dinner buffet', '2026-03-20', 42.00, 'USD', 1, 42.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-20'), 'transport', 'Rental car drop-off fee', '2026-03-21', 35.00, 'USD', 1, 35.00),
((SELECT id FROM destinations WHERE name = 'Las Vegas, NV' AND arrival_date = '2026-03-20'), 'misc', 'Last-minute souvenirs', '2026-03-21', 25.00, 'USD', 1, 25.00);

-- Zurich (CHF)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Zurich'), 'lodging', 'Hotel near Bahnhofstrasse - 3 nights', '2026-12-15', 480.00, 'CHF', 1.242, ROUND(480.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Zurich'), 'transport', 'Swiss Travel Pass', '2026-12-15', 232.00, 'CHF', 1.242, ROUND(232.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Zurich'), 'food', 'Fondue dinner', '2026-12-15', 68.00, 'CHF', 1.242, ROUND(68.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Zurich'), 'food', 'Lunch at Zurich Christmas Market', '2026-12-16', 24.50, 'CHF', 1.242, ROUND(24.50 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Zurich'), 'activities', 'Lake Zurich boat cruise', '2026-12-16', 45.00, 'CHF', 1.242, ROUND(45.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Zurich'), 'misc', 'Chocolate shop souvenirs', '2026-12-17', 38.00, 'CHF', 1.242, ROUND(38.00 * 1.242, 2));

-- Lucerne (CHF)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Lucerne'), 'lodging', 'Hotel by Chapel Bridge - 3 nights', '2026-12-18', 510.00, 'CHF', 1.242, ROUND(510.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Lucerne'), 'food', 'Swiss rösti dinner', '2026-12-18', 32.00, 'CHF', 1.242, ROUND(32.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Lucerne'), 'food', 'Bakery breakfast', '2026-12-19', 12.50, 'CHF', 1.242, ROUND(12.50 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Lucerne'), 'transport', 'Local bus tickets', '2026-12-19', 8.00, 'CHF', 1.242, ROUND(8.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Lucerne'), 'activities', 'Mount Pilatus cable car', '2026-12-20', 90.00, 'CHF', 1.242, ROUND(90.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Lucerne'), 'misc', 'Postcards and stamps', '2026-12-20', 15.00, 'CHF', 1.242, ROUND(15.00 * 1.242, 2));

-- Interlaken (CHF)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Interlaken'), 'lodging', 'Chalet-style guesthouse - 3 nights', '2026-12-21', 450.00, 'CHF', 1.242, ROUND(450.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Interlaken'), 'food', 'Alpine cheese platter dinner', '2026-12-21', 42.00, 'CHF', 1.242, ROUND(42.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Interlaken'), 'food', 'Christmas market snacks', '2026-12-22', 18.00, 'CHF', 1.242, ROUND(18.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Interlaken'), 'transport', 'Train to Jungfraujoch', '2026-12-22', 210.00, 'CHF', 1.242, ROUND(210.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Interlaken'), 'activities', 'Jungfraujoch - Top of Europe ticket', '2026-12-22', 220.00, 'CHF', 1.242, ROUND(220.00 * 1.242, 2)),
((SELECT id FROM destinations WHERE name = 'Interlaken'), 'misc', 'Wool hat and gloves', '2026-12-23', 55.00, 'CHF', 1.242, ROUND(55.00 * 1.242, 2));

-- New York City
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'lodging', 'Hotel in Midtown - 7 nights', '2026-08-29', 1610.00, 'USD', 1, 1610.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'transport', 'Airport taxi (JFK to hotel)', '2026-08-29', 65.00, 'USD', 1, 65.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Pizza slice dinner', '2026-08-29', 12.00, 'USD', 1, 12.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Bagel breakfast', '2026-08-30', 9.50, 'USD', 1, 9.50),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'activities', 'Broadway show ticket', '2026-08-30', 175.00, 'USD', 1, 175.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Dinner in Little Italy', '2026-08-30', 58.00, 'USD', 1, 58.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'transport', 'Subway 7-day pass', '2026-08-31', 34.00, 'USD', 1, 34.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'activities', 'Statue of Liberty ferry', '2026-08-31', 24.00, 'USD', 1, 24.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Deli lunch', '2026-08-31', 16.00, 'USD', 1, 16.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'misc', 'Museum gift shop', '2026-09-01', 27.00, 'USD', 1, 27.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'activities', 'MoMA admission', '2026-09-01', 25.00, 'USD', 1, 25.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Rooftop dinner', '2026-09-01', 95.00, 'USD', 1, 95.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Brunch in Brooklyn', '2026-09-02', 38.00, 'USD', 1, 38.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'activities', 'Central Park bike rental', '2026-09-02', 30.00, 'USD', 1, 30.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'misc', 'Souvenir t-shirts', '2026-09-02', 40.00, 'USD', 1, 40.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Food truck lunch', '2026-09-03', 14.00, 'USD', 1, 14.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'food', 'Steakhouse dinner', '2026-09-03', 110.00, 'USD', 1, 110.00),
((SELECT id FROM destinations WHERE name = 'New York City, NY'), 'transport', 'Uber to airport', '2026-09-04', 70.00, 'USD', 1, 70.00);

-- Tokyo (JPY)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Tokyo'), 'lodging', 'Shinjuku hotel - 4 nights', '2026-04-05', 68000, 'JPY', 0.00626, ROUND(68000 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Tokyo'), 'transport', 'JR Pass activation', '2026-04-05', 29650, 'JPY', 0.00626, ROUND(29650 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Tokyo'), 'food', 'Ramen shop dinner', '2026-04-05', 1200, 'JPY', 0.00626, ROUND(1200 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Tokyo'), 'food', 'Sushi omakase', '2026-04-06', 8500, 'JPY', 0.00626, ROUND(8500 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Tokyo'), 'activities', 'TeamLab Planets ticket', '2026-04-06', 3800, 'JPY', 0.00626, ROUND(3800 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Tokyo'), 'misc', 'Souvenirs in Harajuku', '2026-04-07', 5200, 'JPY', 0.00626, ROUND(5200 * 0.00626, 2));

-- Kyoto (JPY)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Kyoto'), 'lodging', 'Ryokan stay - 4 nights', '2026-04-09', 92000, 'JPY', 0.00626, ROUND(92000 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Kyoto'), 'food', 'Kaiseki dinner', '2026-04-09', 12000, 'JPY', 0.00626, ROUND(12000 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Kyoto'), 'food', 'Street food at Nishiki Market', '2026-04-10', 2400, 'JPY', 0.00626, ROUND(2400 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Kyoto'), 'transport', 'Local bus day pass', '2026-04-10', 600, 'JPY', 0.00626, ROUND(600 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Kyoto'), 'activities', 'Fushimi Inari and Arashiyama tour', '2026-04-11', 6500, 'JPY', 0.00626, ROUND(6500 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Kyoto'), 'misc', 'Kimono rental', '2026-04-12', 4500, 'JPY', 0.00626, ROUND(4500 * 0.00626, 2));

-- Osaka (JPY)
INSERT INTO expenses (destination_id, category, description, expense_date, amount, currency, exchange_rate, amount_usd) VALUES
((SELECT id FROM destinations WHERE name = 'Osaka'), 'lodging', 'Business hotel near Namba - 3 nights', '2026-04-13', 42000, 'JPY', 0.00626, ROUND(42000 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Osaka'), 'food', 'Takoyaki and okonomiyaki dinner', '2026-04-13', 2800, 'JPY', 0.00626, ROUND(2800 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Osaka'), 'food', 'Dotonbori street food crawl', '2026-04-14', 3500, 'JPY', 0.00626, ROUND(3500 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Osaka'), 'transport', 'Osaka subway pass', '2026-04-14', 900, 'JPY', 0.00626, ROUND(900 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Osaka'), 'activities', 'Osaka Castle admission', '2026-04-15', 600, 'JPY', 0.00626, ROUND(600 * 0.00626, 2)),
((SELECT id FROM destinations WHERE name = 'Osaka'), 'misc', 'Snack souvenirs', '2026-04-15', 3200, 'JPY', 0.00626, ROUND(3200 * 0.00626, 2));

-- Mark a couple of lodging expenses as shared among all travelers on the trip (stretch goal)
INSERT INTO expense_travelers (expense_id, traveler_id)
SELECT e.id, t.id
FROM expenses e
JOIN destinations d ON d.id = e.destination_id
JOIN travelers t ON t.trip_id = d.trip_id
WHERE d.name = 'San Francisco, CA'
  AND e.description = 'Hotel Zephyr - 2 nights';

INSERT INTO expense_travelers (expense_id, traveler_id)
SELECT e.id, t.id
FROM expenses e
JOIN destinations d ON d.id = e.destination_id
JOIN travelers t ON t.trip_id = d.trip_id
WHERE d.name = 'Zurich'
  AND e.description = 'Hotel near Bahnhofstrasse - 3 nights';

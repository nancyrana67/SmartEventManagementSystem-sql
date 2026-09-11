-- ============================================================
-- SMART EVENT MANAGEMENT SYSTEM
-- ============================================================

DROP DATABASE IF EXISTS smart_event_management;
CREATE DATABASE smart_event_management;
USE smart_event_management;

-- ============================================================
-- 1. DATABASE SCHEMA
-- ============================================================

CREATE TABLE venues (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    CONSTRAINT chk_venue_capacity CHECK (capacity > 0)
);

CREATE TABLE organizers (
    organizer_id INT PRIMARY KEY AUTO_INCREMENT,
    organizer_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(150),
    phone_number VARCHAR(20)
);

CREATE TABLE attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    phone_number VARCHAR(20)
);

CREATE TABLE events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(150) NOT NULL,
    event_date DATE NOT NULL,
    venue_id INT NOT NULL,
    organizer_id INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    CONSTRAINT chk_ticket_price CHECK (ticket_price >= 0),
    CONSTRAINT chk_total_seats CHECK (total_seats > 0),
    CONSTRAINT chk_available_seats CHECK (available_seats >= 0 AND available_seats <= total_seats),
    CONSTRAINT fk_event_venue
        FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    CONSTRAINT fk_event_organizer
        FOREIGN KEY (organizer_id) REFERENCES organizers(organizer_id)
);

CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    attendee_id INT NOT NULL,
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Confirmed', 'Cancelled', 'Pending') NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT fk_ticket_event
        FOREIGN KEY (event_id) REFERENCES events(event_id),
    CONSTRAINT fk_ticket_attendee
        FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id),
    -- Prevent the same attendee from booking the same event more than once.
    CONSTRAINT uq_attendee_event UNIQUE (event_id, attendee_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Success', 'Failed', 'Pending', 'Refunded') NOT NULL DEFAULT 'Pending',
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_amount_paid CHECK (amount_paid >= 0),
    CONSTRAINT fk_payment_ticket
        FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id)
);



-- ============================================================
-- 2. SAMPLE DATA
-- ============================================================

INSERT INTO venues (venue_name, location, capacity) VALUES
('Grand Convention Hall', 'Ahmedabad', 1000),
('Riverfront Auditorium', 'Ahmedabad', 600),
('Sardar Patel Hall', 'Vadodara', 500),
('Surat Expo Centre', 'Surat', 800),
('Narmada Cultural Centre', 'Bharuch', 350),
('Tech Park Auditorium', 'Gandhinagar', 450);

INSERT INTO organizers (organizer_name, contact_email, phone_number) VALUES
('  Bright Events India  ', 'bright@example.com', '9876500001'),
('Future Fest Team', 'future@example.com', '9876500002'),
('TechSphere Organizers', 'techsphere@example.com', '9876500003'),
('Cultural Connect', 'culture@example.com', '9876500004'),
('Youth Innovation Club', NULL, '9876500005');

INSERT INTO attendees (name, email, phone_number) VALUES
('  Aisha Patel  ', 'aisha@example.com', '9000000001'),
('Rahul Shah', 'rahul@example.com', '9000000002'),
('  Neha Mehta', NULL, '9000000003'),
('Karan Desai  ', 'karan@example.com', '9000000004'),
('  Priya Joshi  ', NULL, '9000000005'),
('Arjun Patel', 'arjun@example.com', '9000000006'),
('Maya Trivedi', 'maya@example.com', '9000000007'),
('Dev Kumar', NULL, '9000000008'),
('Riya Shah', 'riya@example.com', '9000000009'),
('  Om Vora ', 'om@example.com', '9000000010');

INSERT INTO events
(event_name, event_date, venue_id, organizer_id, ticket_price, total_seats, available_seats)
VALUES
('AI & Future Technology Summit', '2026-09-20', 1, 1, 1500.00, 1000, 993),
('Startup Growth Conference', '2026-10-05', 2, 1, 1200.00, 600, 596),
('Diwali Business Meetup', '2026-12-05', 3, 1, 800.00, 500, 498),
('Data Science Workshop', '2026-12-18', 4, 2, 1000.00, 800, 792),
('Music & Culture Night', '2026-11-14', 5, 1, 700.00, 350, 347),
('FinTech Innovation Forum', '2026-12-20', 6, 3, 2000.00, 450, 446),
('Digital Marketing Masterclass', '2027-01-15', 4, 3, 900.00, 800, 796),
('Leadership Excellence Seminar', '2027-02-10', 3, 3, 1100.00, 500, 498),
('Community Charity Walk', '2026-10-25', 5, 4, 300.00, 350, 350),
('Private Planning Workshop', '2027-03-15', 6, 5, 500.00, 450, 450);

INSERT INTO tickets
(event_id, attendee_id, booking_date, status)
VALUES
-- Event 1: 7 attendees
(1, 1, '2026-09-05 10:00:00', 'Confirmed'),
(1, 2, '2026-09-06 11:00:00', 'Confirmed'),
(1, 3, '2026-09-07 12:00:00', 'Confirmed'),
(1, 4, '2026-09-08 13:00:00', 'Confirmed'),
(1, 5, '2026-09-09 14:00:00', 'Confirmed'),
(1, 6, '2026-09-10 15:00:00', 'Confirmed'),
(1, 7, '2026-09-10 16:00:00', 'Pending'),

-- Event 2: 4 attendees
(2, 1, '2026-09-06 09:30:00', 'Confirmed'),
(2, 8, '2026-09-07 10:30:00', 'Confirmed'),
(2, 9, '2026-09-08 11:30:00', 'Confirmed'),
(2, 10, '2026-09-10 12:30:00', 'Pending'),

-- Event 3: December event, 2 attendees
(3, 2, '2026-09-05 09:00:00', 'Confirmed'),
(3, 3, '2026-09-09 09:30:00', 'Confirmed'),

-- Event 4: 8 attendees
(4, 1, '2026-09-04 10:00:00', 'Confirmed'),
(4, 2, '2026-09-05 10:15:00', 'Confirmed'),
(4, 4, '2026-09-06 10:30:00', 'Confirmed'),
(4, 5, '2026-09-07 10:45:00', 'Confirmed'),
(4, 6, '2026-09-08 11:00:00', 'Confirmed'),
(4, 7, '2026-09-09 11:15:00', 'Confirmed'),
(4, 8, '2026-09-10 11:30:00', 'Confirmed'),
(4, 9, '2026-09-10 11:45:00', 'Confirmed'),

-- Event 5: 3 attendees
(5, 3, '2026-09-01 12:00:00', 'Confirmed'),
(5, 4, '2026-09-03 12:15:00', 'Cancelled'),
(5, 10, '2026-09-10 12:30:00', 'Confirmed'),

-- Event 6: 4 attendees
(6, 1, '2026-09-02 13:00:00', 'Confirmed'),
(6, 2, '2026-09-04 13:15:00', 'Confirmed'),
(6, 5, '2026-09-08 13:30:00', 'Confirmed'),
(6, 6, '2026-09-10 13:45:00', 'Confirmed'),

-- Event 7: 2 attendees
(7, 7, '2026-09-09 14:00:00', 'Confirmed'),
(7, 8, '2026-09-10 14:15:00', 'Confirmed'),

-- Event 8: 2 attendees
(8, 9, '2026-09-08 15:00:00', 'Confirmed'),
(8, 10, '2026-09-10 15:15:00', 'Confirmed');

-- Event 9 and Event 10 intentionally have no tickets.

INSERT INTO payments
(ticket_id, amount_paid, payment_status, payment_date)
VALUES
(1, 1500.00, 'Success',  '2026-09-05 10:05:00'),
(2, 1500.00, 'Success',  '2026-09-06 11:05:00'),
(3, 1500.00, 'Success',  '2026-09-07 12:05:00'),
(4, 1500.00, 'Success',  '2026-09-08 13:05:00'),
(5, 1500.00, 'Success',  '2026-09-09 14:05:00'),
(6, 1500.00, 'Success',  '2026-09-10 15:05:00'),
(7, 1500.00, 'Pending',  '2026-09-10 16:05:00'),

(8, 1200.00, 'Success',  '2026-09-06 09:35:00'),
(9, 1200.00, 'Success',  '2026-09-07 10:35:00'),
(10, 1200.00, 'Failed',   '2026-09-08 11:35:00'),
(11, 1200.00, 'Pending',  '2026-09-10 12:35:00'),

(12, 800.00, 'Success',  '2026-09-05 09:05:00'),
(13, 800.00, 'Refunded', '2026-09-09 09:35:00'),

(14, 1000.00, 'Success',  '2026-09-04 10:05:00'),
(15, 1000.00, 'Success',  '2026-09-05 10:20:00'),
(16, 1000.00, 'Success',  '2026-09-06 10:35:00'),
(17, 1000.00, 'Success',  '2026-09-07 10:50:00'),
(18, 1000.00, 'Success',  '2026-09-08 11:05:00'),
(19, 1000.00, 'Success',  '2026-09-09 11:20:00'),
(20, 1000.00, 'Success',  '2026-09-10 11:35:00'),
(21, 1000.00, 'Pending',  '2026-09-10 11:50:00'),

(22, 700.00, 'Success',  '2026-09-01 12:05:00'),
(23, 700.00, 'Failed',   '2026-09-03 12:20:00'),
(24, 700.00, 'Success',  '2026-09-10 12:35:00'),

(25, 2000.00, 'Success',  '2026-09-02 13:05:00'),
(26, 2000.00, 'Success',  '2026-09-04 13:20:00'),
(27, 2000.00, 'Success',  '2026-09-08 13:35:00'),
(28, 2000.00, 'Success',  '2026-09-10 13:50:00'),

(29, 900.00, 'Success',  '2026-09-09 14:05:00'),
(30, 900.00, 'Success',  '2026-09-10 14:20:00'),

(31, 1100.00, 'Success',  '2026-09-08 15:05:00'),
(32, 1100.00, 'Success',  '2026-09-10 15:20:00');

-- ============================================================
-- 3. CRUD OPERATIONS
-- ============================================================

-- The following transaction demonstrates CREATE, READ, UPDATE and DELETE
-- for the main entities without permanently changing the sample database.

START TRANSACTION;

-- -----------------------------
-- CREATE / INSERT
-- -----------------------------
INSERT INTO venues (venue_name, location, capacity)
VALUES ('Demo Event Hall', 'Rajkot', 300);
SET @demo_venue_id = LAST_INSERT_ID();

INSERT INTO organizers (organizer_name, contact_email, phone_number)
VALUES ('Demo Organizer', 'demo.organizer@example.com', '9999999999');
SET @demo_organizer_id = LAST_INSERT_ID();

INSERT INTO attendees (name, email, phone_number)
VALUES ('Demo Attendee', 'demo.attendee@example.com', '9888888888');
SET @demo_attendee_id = LAST_INSERT_ID();

INSERT INTO events
(event_name, event_date, venue_id, organizer_id, ticket_price, total_seats, available_seats)
VALUES
('Demo SQL Event', '2027-04-15', @demo_venue_id, @demo_organizer_id,
 500.00, 300, 299);
SET @demo_event_id = LAST_INSERT_ID();

INSERT INTO tickets (event_id, attendee_id, booking_date, status)
VALUES (@demo_event_id, @demo_attendee_id, NOW(), 'Confirmed');
SET @demo_ticket_id = LAST_INSERT_ID();

INSERT INTO payments (ticket_id, amount_paid, payment_status, payment_date)
VALUES (@demo_ticket_id, 500.00, 'Success', NOW());

-- -----------------------------
-- READ / SELECT
-- -----------------------------
SELECT * FROM venues WHERE venue_id = @demo_venue_id;
+----------+-----------------+----------+----------+
| venue_id | venue_name      | location | capacity |
+----------+-----------------+----------+----------+
|        7 | Demo Event Hall | Rajkot   |      300 |
+----------+-----------------+----------+----------+
1 row in set (0.011 sec)

SELECT * FROM organizers WHERE organizer_id = @demo_organizer_id;
+--------------+----------------+----------------------------+--------------+
| organizer_id | organizer_name | contact_email              | phone_number |
+--------------+----------------+----------------------------+--------------+
|            6 | Demo Organizer | demo.organizer@example.com | 9999999999   |
+--------------+----------------+----------------------------+--------------+
1 row in set (0.009 sec)

SELECT * FROM attendees WHERE attendee_id = @demo_attendee_id;
+-------------+---------------+---------------------------+--------------+
| attendee_id | name          | email                     | phone_number |
+-------------+---------------+---------------------------+--------------+
|          11 | Demo Attendee | demo.attendee@example.com | 9888888888   |
+-------------+---------------+---------------------------+--------------+
1 row in set (0.008 sec)

SELECT * FROM events WHERE event_id = @demo_event_id;
+----------+----------------+------------+----------+--------------+--------------+-------------+-----------------+
| event_id | event_name     | event_date | venue_id | organizer_id | ticket_price | total_seats | available_seats |
+----------+----------------+------------+----------+--------------+--------------+-------------+-----------------+
|       11 | Demo SQL Event | 2027-04-15 |        7 |            6 |       500.00 |         300 |             299 |
+----------+----------------+------------+----------+--------------+--------------+-------------+-----------------+
1 row in set (0.013 sec)

SELECT * FROM tickets WHERE ticket_id = @demo_ticket_id;
+-----------+----------+-------------+---------------------+-----------+
| ticket_id | event_id | attendee_id | booking_date        | status    |
+-----------+----------+-------------+---------------------+-----------+
|        33 |       11 |          11 | 2026-09-11 22:13:38 | Confirmed |
+-----------+----------+-------------+---------------------+-----------+
1 row in set (0.003 sec)

SELECT * FROM payments WHERE ticket_id = @demo_ticket_id;
+------------+-----------+-------------+----------------+---------------------+
| payment_id | ticket_id | amount_paid | payment_status | payment_date        |
+------------+-----------+-------------+----------------+---------------------+
|         33 |        33 |      500.00 | Success        | 2026-09-11 22:13:39 |
+------------+-----------+-------------+----------------+---------------------+
1 row in set (0.015 sec)


 -- Search examples.


SELECT * FROM events WHERE event_name LIKE '%Demo%';
+----------+----------------+------------+----------+--------------+--------------+-------------+-----------------+
| event_id | event_name     | event_date | venue_id | organizer_id | ticket_price | total_seats | available_seats |
+----------+----------------+------------+----------+--------------+--------------+-------------+-----------------+
|       11 | Demo SQL Event | 2027-04-15 |        7 |            6 |       500.00 |         300 |             299 |
+----------+----------------+------------+----------+--------------+--------------+-------------+-----------------+
1 row in set (0.015 sec)

SELECT * FROM venues WHERE location LIKE '%Rajkot%';
+----------+-----------------+----------+----------+
| venue_id | venue_name      | location | capacity |
+----------+-----------------+----------+----------+
|        7 | Demo Event Hall | Rajkot   |      300 |
+----------+-----------------+----------+----------+
1 row in set (0.004 sec)

SELECT * FROM organizers WHERE organizer_name LIKE '%Demo%';
+--------------+----------------+----------------------------+--------------+
| organizer_id | organizer_name | contact_email              | phone_number |
+--------------+----------------+----------------------------+--------------+
|            6 | Demo Organizer | demo.organizer@example.com | 9999999999   |
+--------------+----------------+----------------------------+--------------+
1 row in set (0.002 sec)

SELECT * FROM attendees WHERE name LIKE '%Demo%';
+-------------+---------------+---------------------------+--------------+
| attendee_id | name          | email                     | phone_number |
+-------------+---------------+---------------------------+--------------+
|          11 | Demo Attendee | demo.attendee@example.com | 9888888888   |
+-------------+---------------+---------------------------+--------------+
1 row in set (0.002 sec)

SELECT * FROM tickets WHERE status = 'Confirmed';
+-----------+----------+-------------+---------------------+-----------+
| ticket_id | event_id | attendee_id | booking_date        | status    |
+-----------+----------+-------------+---------------------+-----------+
|         1 |        1 |           1 | 2026-09-05 10:00:00 | Confirmed |
|         2 |        1 |           2 | 2026-09-06 11:00:00 | Confirmed |
|         3 |        1 |           3 | 2026-09-07 12:00:00 | Confirmed |
|         4 |        1 |           4 | 2026-09-08 13:00:00 | Confirmed |
|         5 |        1 |           5 | 2026-09-09 14:00:00 | Confirmed |
|         6 |        1 |           6 | 2026-09-10 15:00:00 | Confirmed |
|         8 |        2 |           1 | 2026-09-06 09:30:00 | Confirmed |
|         9 |        2 |           8 | 2026-09-07 10:30:00 | Confirmed |
|        10 |        2 |           9 | 2026-09-08 11:30:00 | Confirmed |
|        12 |        3 |           2 | 2026-09-05 09:00:00 | Confirmed |
|        13 |        3 |           3 | 2026-09-09 09:30:00 | Confirmed |
|        14 |        4 |           1 | 2026-09-04 10:00:00 | Confirmed |
|        15 |        4 |           2 | 2026-09-05 10:15:00 | Confirmed |
|        16 |        4 |           4 | 2026-09-06 10:30:00 | Confirmed |
|        17 |        4 |           5 | 2026-09-07 10:45:00 | Confirmed |
|        18 |        4 |           6 | 2026-09-08 11:00:00 | Confirmed |
|        19 |        4 |           7 | 2026-09-09 11:15:00 | Confirmed |
|        20 |        4 |           8 | 2026-09-10 11:30:00 | Confirmed |
|        21 |        4 |           9 | 2026-09-10 11:45:00 | Confirmed |
|        22 |        5 |           3 | 2026-09-01 12:00:00 | Confirmed |
|        24 |        5 |          10 | 2026-09-10 12:30:00 | Confirmed |
|        25 |        6 |           1 | 2026-09-02 13:00:00 | Confirmed |
|        26 |        6 |           2 | 2026-09-04 13:15:00 | Confirmed |
|        27 |        6 |           5 | 2026-09-08 13:30:00 | Confirmed |
|        28 |        6 |           6 | 2026-09-10 13:45:00 | Confirmed |
|        29 |        7 |           7 | 2026-09-09 14:00:00 | Confirmed |
|        30 |        7 |           8 | 2026-09-10 14:15:00 | Confirmed |
|        31 |        8 |           9 | 2026-09-08 15:00:00 | Confirmed |
|        32 |        8 |          10 | 2026-09-10 15:15:00 | Confirmed |
|        33 |       11 |          11 | 2026-09-11 22:13:38 | Confirmed |
+-----------+----------+-------------+---------------------+-----------+


-- -----------------------------
-- UPDATE
-- -----------------------------
UPDATE venues
SET capacity = 350
WHERE venue_id = @demo_venue_id;

UPDATE organizers
SET phone_number = '9777777777'
WHERE organizer_id = @demo_organizer_id;

UPDATE attendees
SET phone_number = '9666666666'
WHERE attendee_id = @demo_attendee_id;

UPDATE events
SET ticket_price = 550.00
WHERE event_id = @demo_event_id;

-- Modify a ticket booking.
UPDATE tickets
SET status = 'Pending'
WHERE ticket_id = @demo_ticket_id;

-- Cancel a ticket booking example:
-- UPDATE tickets SET status = 'Cancelled'
-- WHERE ticket_id = @demo_ticket_id;

-- -----------------------------
-- DELETE
-- -----------------------------
-- Delete child records first because of foreign-key dependencies.
DELETE FROM payments
WHERE ticket_id = @demo_ticket_id;

DELETE FROM tickets
WHERE ticket_id = @demo_ticket_id;

DELETE FROM events
WHERE event_id = @demo_event_id;

DELETE FROM attendees
WHERE attendee_id = @demo_attendee_id;

DELETE FROM organizers
WHERE organizer_id = @demo_organizer_id;

DELETE FROM venues
WHERE venue_id = @demo_venue_id;

-- Roll back the demonstration so the original sample dataset remains unchanged.
ROLLBACK;
-- output of this all query : Query OK, 0 rows affected (0.128 sec)
-- ============================================================
-- 4. WHERE, HAVING, LIMIT
-- ============================================================

-- 4.1 Upcoming events happening in a specific city.
SELECT e.event_id, e.event_name, e.event_date, v.venue_name, v.location
FROM events e
JOIN venues v ON e.venue_id = v.venue_id
WHERE e.event_date >= CURDATE()
  AND v.location = 'Ahmedabad'
ORDER BY e.event_date;
+----------+-------------------------------+------------+-----------------------+-----------+
| event_id | event_name                    | event_date | venue_name            | location  |
+----------+-------------------------------+------------+-----------------------+-----------+
|        1 | AI & Future Technology Summit | 2026-09-20 | Grand Convention Hall | Ahmedabad |
|        2 | Startup Growth Conference     | 2026-10-05 | Riverfront Auditorium | Ahmedabad |
+----------+-------------------------------+------------+-----------------------+-----------+


-- 4.2 Top 5 highest revenue-generating events.
SELECT
    e.event_id,
    e.event_name,
    COALESCE(SUM(CASE WHEN p.payment_status = 'Success'
                      THEN p.amount_paid ELSE 0 END), 0) AS total_revenue
FROM events e
LEFT JOIN tickets t ON e.event_id = t.event_id
LEFT JOIN payments p ON t.ticket_id = p.ticket_id
GROUP BY e.event_id, e.event_name
ORDER BY total_revenue DESC
LIMIT 5;
+----------+-------------------------------+---------------+
| event_id | event_name                    | total_revenue |
+----------+-------------------------------+---------------+
|        1 | AI & Future Technology Summit |       9000.00 |
|        6 | FinTech Innovation Forum      |       8000.00 |
|        4 | Data Science Workshop         |       7000.00 |
|        2 | Startup Growth Conference     |       2400.00 |
|        8 | Leadership Excellence Seminar |       2200.00 |
+----------+-------------------------------+---------------+


-- 4.3 Attendees who booked tickets in the last 7 days.
SELECT
    a.attendee_id,
    TRIM(a.name) AS attendee_name,
    t.ticket_id,
    t.booking_date,
    t.status
FROM attendees a
JOIN tickets t ON a.attendee_id = t.attendee_id
WHERE t.booking_date >= NOW() - INTERVAL 7 DAY
ORDER BY t.booking_date DESC;
+-------------+---------------+-----------+---------------------+-----------+
| attendee_id | attendee_name | ticket_id | booking_date        | status    |
+-------------+---------------+-----------+---------------------+-----------+
|           7 | Maya Trivedi  |         7 | 2026-09-10 16:00:00 | Pending   |
|          10 | Om Vora       |        32 | 2026-09-10 15:15:00 | Confirmed |
|           6 | Arjun Patel   |         6 | 2026-09-10 15:00:00 | Confirmed |
|           8 | Dev Kumar     |        30 | 2026-09-10 14:15:00 | Confirmed |
|           6 | Arjun Patel   |        28 | 2026-09-10 13:45:00 | Confirmed |
|          10 | Om Vora       |        11 | 2026-09-10 12:30:00 | Pending   |
|          10 | Om Vora       |        24 | 2026-09-10 12:30:00 | Confirmed |
|           9 | Riya Shah     |        21 | 2026-09-10 11:45:00 | Confirmed |
|           8 | Dev Kumar     |        20 | 2026-09-10 11:30:00 | Confirmed |
|           5 | Priya Joshi   |         5 | 2026-09-09 14:00:00 | Confirmed |
|           7 | Maya Trivedi  |        29 | 2026-09-09 14:00:00 | Confirmed |
|           7 | Maya Trivedi  |        19 | 2026-09-09 11:15:00 | Confirmed |
|           3 | Neha Mehta    |        13 | 2026-09-09 09:30:00 | Confirmed |
|           9 | Riya Shah     |        31 | 2026-09-08 15:00:00 | Confirmed |
|           5 | Priya Joshi   |        27 | 2026-09-08 13:30:00 | Confirmed |
|           4 | Karan Desai   |         4 | 2026-09-08 13:00:00 | Confirmed |
|           9 | Riya Shah     |        10 | 2026-09-08 11:30:00 | Confirmed |
|           6 | Arjun Patel   |        18 | 2026-09-08 11:00:00 | Confirmed |
|           3 | Neha Mehta    |         3 | 2026-09-07 12:00:00 | Confirmed |
|           5 | Priya Joshi   |        17 | 2026-09-07 10:45:00 | Confirmed |
|           8 | Dev Kumar     |         9 | 2026-09-07 10:30:00 | Confirmed |
|           2 | Rahul Shah    |         2 | 2026-09-06 11:00:00 | Confirmed |
|           4 | Karan Desai   |        16 | 2026-09-06 10:30:00 | Confirmed |
|           1 | Aisha Patel   |         8 | 2026-09-06 09:30:00 | Confirmed |
|           2 | Rahul Shah    |        15 | 2026-09-05 10:15:00 | Confirmed |
|           1 | Aisha Patel   |         1 | 2026-09-05 10:00:00 | Confirmed |
|           2 | Rahul Shah    |        12 | 2026-09-05 09:00:00 | Confirmed |
+-------------+---------------+-----------+---------------------+-----------+


-- ============================================================
-- 5. SQL OPERATORS: AND, OR, NOT
-- ============================================================

-- 5.1 Events in December AND with more than 50% available seats.
SELECT
    event_id,
    event_name,
    event_date,
    available_seats,
    total_seats
FROM events
WHERE MONTH(event_date) = 12
AND available_seats > (total_seats * 0.50);
+----------+--------------------------+------------+-----------------+-------------+
| event_id | event_name               | event_date | available_seats | total_seats |
+----------+--------------------------+------------+-----------------+-------------+
|        3 | Diwali Business Meetup   | 2026-12-05 |             498 |         500 |
|        4 | Data Science Workshop    | 2026-12-18 |             792 |         800 |
|        6 | FinTech Innovation Forum | 2026-12-20 |             446 |         450 |
+----------+--------------------------+------------+-----------------+-------------+


-- 5.2 Attendees who booked a ticket OR have a pending payment.
SELECT DISTINCT
    a.attendee_id,
    TRIM(a.name) AS attendee_name
FROM attendees a
LEFT JOIN tickets t ON a.attendee_id = t.attendee_id
LEFT JOIN payments p ON t.ticket_id = p.ticket_id
WHERE t.ticket_id IS NOT NULL
   OR p.payment_status = 'Pending';
+-------------+---------------+
| attendee_id | attendee_name |
+-------------+---------------+
|           1 | Aisha Patel   |
|           2 | Rahul Shah    |
|           3 | Neha Mehta    |
|           4 | Karan Desai   |
|           5 | Priya Joshi   |
|           6 | Arjun Patel   |
|           7 | Maya Trivedi  |
|           8 | Dev Kumar     |
|           9 | Riya Shah     |
|          10 | Om Vora       |
+-------------+---------------+
-- 5.3 Events that are NOT fully booked.
SELECT
    event_id,
    event_name,
    total_seats,
    available_seats
FROM events
WHERE NOT (available_seats = 0);
+----------+-------------------------------+-------------+-----------------+
| event_id | event_name                    | total_seats | available_seats |
+----------+-------------------------------+-------------+-----------------+
|        1 | AI & Future Technology Summit |        1000 |             993 |
|        2 | Startup Growth Conference     |         600 |             596 |
|        3 | Diwali Business Meetup        |         500 |             498 |
|        4 | Data Science Workshop         |         800 |             792 |
|        5 | Music & Culture Night         |         350 |             347 |
|        6 | FinTech Innovation Forum      |         450 |             446 |
|        7 | Digital Marketing Masterclass |         800 |             796 |
|        8 | Leadership Excellence Seminar |         500 |             498 |
|        9 | Community Charity Walk        |         350 |             350 |
|       10 | Private Planning Workshop     |         450 |             450 |
+----------+-------------------------------+-------------+-----------------+


-- ============================================================
-- 6. SORTING & GROUPING: ORDER BY, GROUP BY
-- ============================================================

-- 6.1 Sort events by date in ascending order.
SELECT event_id, event_name, event_date
FROM events
ORDER BY event_date ASC;
+----------+-------------------------------+------------+
| event_id | event_name                    | event_date |
+----------+-------------------------------+------------+
|        1 | AI & Future Technology Summit | 2026-09-20 |
|        2 | Startup Growth Conference     | 2026-10-05 |
|        9 | Community Charity Walk        | 2026-10-25 |
|        5 | Music & Culture Night         | 2026-11-14 |
|        3 | Diwali Business Meetup        | 2026-12-05 |
|        4 | Data Science Workshop         | 2026-12-18 |
|        6 | FinTech Innovation Forum      | 2026-12-20 |
|        7 | Digital Marketing Masterclass | 2027-01-15 |
|        8 | Leadership Excellence Seminar | 2027-02-10 |
|       10 | Private Planning Workshop     | 2027-03-15 |
+----------+-------------------------------+------------+
10 rows in set (0.014 sec)


-- 6.2 Count attendees per event.
SELECT
    e.event_id,
    e.event_name,
    COUNT(CASE WHEN t.status <> 'Cancelled' THEN t.ticket_id END) AS attendee_count
FROM events e
LEFT JOIN tickets t ON e.event_id = t.event_id
GROUP BY e.event_id, e.event_name
ORDER BY attendee_count DESC;
+----------+-------------------------------+----------------+
| event_id | event_name                    | attendee_count |
+----------+-------------------------------+----------------+
|        4 | Data Science Workshop         |              8 |
|        1 | AI & Future Technology Summit |              7 |
|        2 | Startup Growth Conference     |              4 |
|        6 | FinTech Innovation Forum      |              4 |
|        3 | Diwali Business Meetup        |              2 |
|        5 | Music & Culture Night         |              2 |
|        7 | Digital Marketing Masterclass |              2 |
|        8 | Leadership Excellence Seminar |              2 |
|        9 | Community Charity Walk        |              0 |
|       10 | Private Planning Workshop     |              0 |
+----------+-------------------------------+----------------+


-- 6.3 Total revenue generated per event.
SELECT
    e.event_id,
    e.event_name,
    COALESCE(SUM(CASE WHEN p.payment_status = 'Success'
                      THEN p.amount_paid ELSE 0 END), 0) AS total_revenue
FROM events e
LEFT JOIN tickets t ON e.event_id = t.event_id
LEFT JOIN payments p ON t.ticket_id = p.ticket_id
GROUP BY e.event_id, e.event_name
ORDER BY total_revenue DESC;
+----------+-------------------------------+---------------+
| event_id | event_name                    | total_revenue |
+----------+-------------------------------+---------------+
|        1 | AI & Future Technology Summit |       9000.00 |
|        6 | FinTech Innovation Forum      |       8000.00 |
|        4 | Data Science Workshop         |       7000.00 |
|        2 | Startup Growth Conference     |       2400.00 |
|        8 | Leadership Excellence Seminar |       2200.00 |
|        7 | Digital Marketing Masterclass |       1800.00 |
|        5 | Music & Culture Night         |       1400.00 |
|        3 | Diwali Business Meetup        |        800.00 |
|        9 | Community Charity Walk        |          0.00 |
|       10 | Private Planning Workshop     |          0.00 |
+----------+-------------------------------+---------------+


-- ============================================================
-- 7. AGGREGATE FUNCTIONS: SUM, AVG, MAX, MIN, COUNT
-- ============================================================

-- 7.1 Total revenue generated from all events.
SELECT
    SUM(amount_paid) AS total_revenue
FROM payments
WHERE payment_status = 'Success';
+---------------+
| total_revenue |
+---------------+
|      32600.00 |
+---------------+

-- 7.2 Event with the highest number of attendees.
SELECT
    e.event_id,
    e.event_name,
    COUNT(t.ticket_id) AS attendee_count
FROM events e
JOIN tickets t ON e.event_id = t.event_id
WHERE t.status <> 'Cancelled'
GROUP BY e.event_id, e.event_name
ORDER BY attendee_count DESC
LIMIT 1;
+----------+-----------------------+----------------+
| event_id | event_name            | attendee_count |
+----------+-----------------------+----------------+
|        4 | Data Science Workshop |              8 |
+----------+-----------------------+----------------+

-- 7.3 Average ticket price across all events.
SELECT AVG(ticket_price) AS average_ticket_price
FROM events;
+----------------------+
| average_ticket_price |
+----------------------+
|          1000.000000 |
+----------------------+

-- Additional aggregate examples using MAX, MIN and COUNT.
SELECT
    MAX(ticket_price) AS highest_ticket_price,
    MIN(ticket_price) AS lowest_ticket_price,
    COUNT(*) AS total_events
FROM events;
+----------------------+---------------------+--------------+
| highest_ticket_price | lowest_ticket_price | total_events |
+----------------------+---------------------+--------------+
|              2000.00 |              300.00 |           10 |
+----------------------+---------------------+--------------+

-- ============================================================
-- 8. PRIMARY & FOREIGN KEY RELATIONSHIPS
-- ============================================================

-- The UNIQUE(event_id, attendee_id) constraint prevents duplicate
-- bookings for the same attendee and event.
-- This example is intentionally commented because it should fail:
-- INSERT INTO tickets (event_id, attendee_id, booking_date, status)
-- VALUES (1, 1, NOW(), 'Confirmed');

-- Payments are linked to tickets through payments.ticket_id.
SELECT
    p.payment_id,
    p.ticket_id,
    t.event_id,
    t.attendee_id,
    p.amount_paid,
    p.payment_status
FROM payments p
JOIN tickets t ON p.ticket_id = t.ticket_id;
+------------+-----------+----------+-------------+-------------+----------------+
| payment_id | ticket_id | event_id | attendee_id | amount_paid | payment_status |
+------------+-----------+----------+-------------+-------------+----------------+
|          1 |         1 |        1 |           1 |     1500.00 | Success        |
|          2 |         2 |        1 |           2 |     1500.00 | Success        |
|          3 |         3 |        1 |           3 |     1500.00 | Success        |
|          4 |         4 |        1 |           4 |     1500.00 | Success        |
|          5 |         5 |        1 |           5 |     1500.00 | Success        |
|          6 |         6 |        1 |           6 |     1500.00 | Success        |
|          7 |         7 |        1 |           7 |     1500.00 | Pending        |
|          8 |         8 |        2 |           1 |     1200.00 | Success        |
|          9 |         9 |        2 |           8 |     1200.00 | Success        |
|         10 |        10 |        2 |           9 |     1200.00 | Failed         |
|         11 |        11 |        2 |          10 |     1200.00 | Pending        |
|         12 |        12 |        3 |           2 |      800.00 | Success        |
|         13 |        13 |        3 |           3 |      800.00 | Refunded       |
|         14 |        14 |        4 |           1 |     1000.00 | Success        |
|         15 |        15 |        4 |           2 |     1000.00 | Success        |
|         16 |        16 |        4 |           4 |     1000.00 | Success        |
|         17 |        17 |        4 |           5 |     1000.00 | Success        |
|         18 |        18 |        4 |           6 |     1000.00 | Success        |
|         19 |        19 |        4 |           7 |     1000.00 | Success        |
|         20 |        20 |        4 |           8 |     1000.00 | Success        |
|         21 |        21 |        4 |           9 |     1000.00 | Pending        |
|         22 |        22 |        5 |           3 |      700.00 | Success        |
|         23 |        23 |        5 |           4 |      700.00 | Failed         |
|         24 |        24 |        5 |          10 |      700.00 | Success        |
|         25 |        25 |        6 |           1 |     2000.00 | Success        |
|         26 |        26 |        6 |           2 |     2000.00 | Success        |
|         27 |        27 |        6 |           5 |     2000.00 | Success        |
|         28 |        28 |        6 |           6 |     2000.00 | Success        |
|         29 |        29 |        7 |           7 |      900.00 | Success        |
|         30 |        30 |        7 |           8 |      900.00 | Success        |
|         31 |        31 |        8 |           9 |     1100.00 | Success        |
|         32 |        32 |        8 |          10 |     1100.00 | Success        |
+------------+-----------+----------+-------------+-------------+----------------+

-- ============================================================
-- 9. JOINS
-- ============================================================

-- 9.1 INNER JOIN: event details + venue information.
SELECT
    e.event_id,
    e.event_name,
    e.event_date,
    v.venue_name,
    v.location,
    v.capacity
FROM events e
INNER JOIN venues v ON e.venue_id = v.venue_id
ORDER BY e.event_date;
+----------+-------------------------------+------------+-------------------------+-------------+----------+
| event_id | event_name                    | event_date | venue_name              | location    | capacity |
+----------+-------------------------------+------------+-------------------------+-------------+----------+
|        1 | AI & Future Technology Summit | 2026-09-20 | Grand Convention Hall   | Ahmedabad   |     1000 |
|        2 | Startup Growth Conference     | 2026-10-05 | Riverfront Auditorium   | Ahmedabad   |      600 |
|        9 | Community Charity Walk        | 2026-10-25 | Narmada Cultural Centre | Bharuch     |      350 |
|        5 | Music & Culture Night         | 2026-11-14 | Narmada Cultural Centre | Bharuch     |      350 |
|        3 | Diwali Business Meetup        | 2026-12-05 | Sardar Patel Hall       | Vadodara    |      500 |
|        4 | Data Science Workshop         | 2026-12-18 | Surat Expo Centre       | Surat       |      800 |
|        6 | FinTech Innovation Forum      | 2026-12-20 | Tech Park Auditorium    | Gandhinagar |      450 |
|        7 | Digital Marketing Masterclass | 2027-01-15 | Surat Expo Centre       | Surat       |      800 |
|        8 | Leadership Excellence Seminar | 2027-02-10 | Sardar Patel Hall       | Vadodara    |      500 |
|       10 | Private Planning Workshop     | 2027-03-15 | Tech Park Auditorium    | Gandhinagar |      450 |
+----------+-------------------------------+------------+-------------------------+-------------+----------+


-- 9.2 LEFT JOIN: attendees who booked a ticket but did not
-- complete payment (no successful payment).
SELECT DISTINCT
    a.attendee_id,
    TRIM(a.name) AS attendee_name,
    t.ticket_id,
    e.event_name,
    p.payment_status
FROM attendees a
LEFT JOIN tickets t ON a.attendee_id = t.attendee_id
LEFT JOIN events e ON t.event_id = e.event_id
LEFT JOIN payments p ON t.ticket_id = p.ticket_id
WHERE t.ticket_id IS NOT NULL
  AND (p.payment_id IS NULL OR p.payment_status <> 'Success');
+-------------+---------------+-----------+-------------------------------+----------------+
| attendee_id | attendee_name | ticket_id | event_name                    | payment_status |
+-------------+---------------+-----------+-------------------------------+----------------+
|           3 | Neha Mehta    |        13 | Diwali Business Meetup        | Refunded       |
|           4 | Karan Desai   |        23 | Music & Culture Night         | Failed         |
|           7 | Maya Trivedi  |         7 | AI & Future Technology Summit | Pending        |
|           9 | Riya Shah     |        10 | Startup Growth Conference     | Failed         |
|           9 | Riya Shah     |        21 | Data Science Workshop         | Pending        |
|          10 | Om Vora       |        11 | Startup Growth Conference     | Pending        |
+-------------+---------------+-----------+-------------------------------+----------------+

-- 9.3 RIGHT JOIN: identify events without any attendees.
-- RIGHT JOIN is used explicitly as required by the assignment.
SELECT
    e.event_id,
    e.event_name,
    t.ticket_id,
    t.attendee_id
FROM tickets t
RIGHT JOIN events e ON t.event_id = e.event_id
WHERE t.ticket_id IS NULL;
+----------+---------------------------+-----------+-------------+
| event_id | event_name                | ticket_id | attendee_id |
+----------+---------------------------+-----------+-------------+
|        9 | Community Charity Walk    |      NULL |        NULL |
|       10 | Private Planning Workshop |      NULL |        NULL |
+----------+---------------------------+-----------+-------------+


-- 9.4 FULL OUTER JOIN simulation in MySQL.
-- MySQL does not support FULL OUTER JOIN directly, so LEFT JOIN
-- UNION RIGHT JOIN is used.
SELECT
    a.attendee_id,
    TRIM(a.name) AS attendee_name,
    t.ticket_id,
    t.event_id
FROM attendees a
LEFT JOIN tickets t ON a.attendee_id = t.attendee_id

UNION

SELECT
    a.attendee_id,
    TRIM(a.name) AS attendee_name,
    t.ticket_id,
    t.event_id
FROM attendees a
RIGHT JOIN tickets t ON a.attendee_id = t.attendee_id;
+-------------+---------------+-----------+----------+
| attendee_id | attendee_name | ticket_id | event_id |
+-------------+---------------+-----------+----------+
|           1 | Aisha Patel   |         1 |        1 |
|           1 | Aisha Patel   |         8 |        2 |
|           1 | Aisha Patel   |        14 |        4 |
|           1 | Aisha Patel   |        25 |        6 |
|           2 | Rahul Shah    |         2 |        1 |
|           2 | Rahul Shah    |        12 |        3 |
|           2 | Rahul Shah    |        15 |        4 |
|           2 | Rahul Shah    |        26 |        6 |
|           3 | Neha Mehta    |         3 |        1 |
|           3 | Neha Mehta    |        13 |        3 |
|           3 | Neha Mehta    |        22 |        5 |
|           4 | Karan Desai   |         4 |        1 |
|           4 | Karan Desai   |        16 |        4 |
|           4 | Karan Desai   |        23 |        5 |
|           5 | Priya Joshi   |         5 |        1 |
|           5 | Priya Joshi   |        17 |        4 |
|           5 | Priya Joshi   |        27 |        6 |
|           6 | Arjun Patel   |         6 |        1 |
|           6 | Arjun Patel   |        18 |        4 |
|           6 | Arjun Patel   |        28 |        6 |
|           7 | Maya Trivedi  |         7 |        1 |
|           7 | Maya Trivedi  |        19 |        4 |
|           7 | Maya Trivedi  |        29 |        7 |
|           8 | Dev Kumar     |         9 |        2 |
|           8 | Dev Kumar     |        20 |        4 |
|           8 | Dev Kumar     |        30 |        7 |
|           9 | Riya Shah     |        10 |        2 |
|           9 | Riya Shah     |        21 |        4 |
|           9 | Riya Shah     |        31 |        8 |
|          10 | Om Vora       |        11 |        2 |
|          10 | Om Vora       |        24 |        5 |
|          10 | Om Vora       |        32 |        8 |
+-------------+---------------+-----------+----------+
-- To show specifically attendees who have NOT booked any ticket:
SELECT
    a.attendee_id,
    TRIM(a.name) AS attendee_name
FROM attendees a
LEFT JOIN tickets t ON a.attendee_id = t.attendee_id
WHERE t.ticket_id IS NULL;
-output : Empty set (0.014 sec)
-- ============================================================
-- 10. SUBQUERIES
-- ============================================================

-- 10.1 Events whose generated revenue is above the average
-- event revenue.
SELECT
    e.event_id,
    e.event_name,
    COALESCE(SUM(CASE WHEN p.payment_status = 'Success'
                      THEN p.amount_paid ELSE 0 END), 0) AS event_revenue
FROM events e
LEFT JOIN tickets t ON e.event_id = t.event_id
LEFT JOIN payments p ON t.ticket_id = p.ticket_id
GROUP BY e.event_id, e.event_name
HAVING event_revenue > (
    SELECT AVG(event_revenue)
    FROM (
        SELECT
            e2.event_id,
            COALESCE(SUM(CASE WHEN p2.payment_status = 'Success'
                              THEN p2.amount_paid ELSE 0 END), 0) AS event_revenue
        FROM events e2
        LEFT JOIN tickets t2 ON e2.event_id = t2.event_id
        LEFT JOIN payments p2 ON t2.ticket_id = p2.ticket_id
        GROUP BY e2.event_id
    ) AS event_revenue_summary
)
ORDER BY event_revenue DESC;
+----------+-------------------------------+---------------+
| event_id | event_name                    | event_revenue |
+----------+-------------------------------+---------------+
|        1 | AI & Future Technology Summit |       9000.00 |
|        6 | FinTech Innovation Forum      |       8000.00 |
|        4 | Data Science Workshop         |       7000.00 |
+----------+-------------------------------+---------------+


-- 10.2 Attendees who have booked tickets for multiple events.
SELECT
    a.attendee_id,
    TRIM(a.name) AS attendee_name,
    COUNT(DISTINCT t.event_id) AS events_booked
FROM attendees a
JOIN tickets t ON a.attendee_id = t.attendee_id
WHERE t.status <> 'Cancelled'
GROUP BY a.attendee_id, a.name
HAVING COUNT(DISTINCT t.event_id) > 1
ORDER BY events_booked DESC;
+-------------+---------------+---------------+
| attendee_id | attendee_name | events_booked |
+-------------+---------------+---------------+
|           1 | Aisha Patel   |             4 |
|           2 | Rahul Shah    |             4 |
|           3 | Neha Mehta    |             3 |
|           5 | Priya Joshi   |             3 |
|           6 | Arjun Patel   |             3 |
|           7 | Maya Trivedi  |             3 |
|           8 | Dev Kumar     |             3 |
|           9 | Riya Shah     |             3 |
|          10 | Om Vora       |             3 |
|           4 | Karan Desai   |             2 |
+-------------+---------------+---------------+

-- 10.3 Organizers who have managed more than 3 events.
SELECT
    o.organizer_id,
    o.organizer_name,
    COUNT(e.event_id) AS events_managed
FROM organizers o
JOIN events e ON o.organizer_id = e.organizer_id
GROUP BY o.organizer_id, o.organizer_name
HAVING COUNT(e.event_id) > 3;
+--------------+-------------------------+----------------+
| organizer_id | organizer_name          | events_managed |
+--------------+-------------------------+----------------+
|            1 |   Bright Events India   |              4 |
+--------------+-------------------------+----------------+

-- ============================================================
-- 11. DATE & TIME FUNCTIONS
-- ============================================================

-- 11.1 Extract month from event_date.
SELECT
    event_id,
    event_name,
    event_date,
    MONTH(event_date) AS event_month,
    MONTHNAME(event_date) AS event_month_name
FROM events
ORDER BY event_date;
+----------+-------------------------------+------------+-------------+------------------+
| event_id | event_name                    | event_date | event_month | event_month_name |
+----------+-------------------------------+------------+-------------+------------------+
|        1 | AI & Future Technology Summit | 2026-09-20 |           9 | September        |
|        2 | Startup Growth Conference     | 2026-10-05 |          10 | October          |
|        9 | Community Charity Walk        | 2026-10-25 |          10 | October          |
|        5 | Music & Culture Night         | 2026-11-14 |          11 | November         |
|        3 | Diwali Business Meetup        | 2026-12-05 |          12 | December         |
|        4 | Data Science Workshop         | 2026-12-18 |          12 | December         |
|        6 | FinTech Innovation Forum      | 2026-12-20 |          12 | December         |
|        7 | Digital Marketing Masterclass | 2027-01-15 |           1 | January          |
|        8 | Leadership Excellence Seminar | 2027-02-10 |           2 | February         |
|       10 | Private Planning Workshop     | 2027-03-15 |           3 | March            |
+----------+-------------------------------+------------+-------------+------------------+

-- 11.2 Number of days remaining for an upcoming event.
SELECT
    event_id,
    event_name,
    event_date,
    DATEDIFF(event_date, CURDATE()) AS days_remaining
FROM events
WHERE event_date >= CURDATE()
ORDER BY event_date;
+----------+-------------------------------+------------+----------------+
| event_id | event_name                    | event_date | days_remaining |
+----------+-------------------------------+------------+----------------+
|        1 | AI & Future Technology Summit | 2026-09-20 |              9 |
|        2 | Startup Growth Conference     | 2026-10-05 |             24 |
|        9 | Community Charity Walk        | 2026-10-25 |             44 |
|        5 | Music & Culture Night         | 2026-11-14 |             64 |
|        3 | Diwali Business Meetup        | 2026-12-05 |             85 |
|        4 | Data Science Workshop         | 2026-12-18 |             98 |
|        6 | FinTech Innovation Forum      | 2026-12-20 |            100 |
|        7 | Digital Marketing Masterclass | 2027-01-15 |            126 |
|        8 | Leadership Excellence Seminar | 2027-02-10 |            152 |
|       10 | Private Planning Workshop     | 2027-03-15 |            185 |
+----------+-------------------------------+------------+----------------+


-- 11.3 Format payment_date as YYYY-MM-DD HH:MM:SS.
SELECT
    payment_id,
    DATE_FORMAT(payment_date, '%Y-%m-%d %H:%i:%s') AS formatted_payment_date
FROM payments
ORDER BY payment_date;
+------------+------------------------+
| payment_id | formatted_payment_date |
+------------+------------------------+
|         22 | 2026-09-01 12:05:00    |
|         25 | 2026-09-02 13:05:00    |
|         23 | 2026-09-03 12:20:00    |
|         14 | 2026-09-04 10:05:00    |
|         26 | 2026-09-04 13:20:00    |
|         12 | 2026-09-05 09:05:00    |
|          1 | 2026-09-05 10:05:00    |
|         15 | 2026-09-05 10:20:00    |
|          8 | 2026-09-06 09:35:00    |
|         16 | 2026-09-06 10:35:00    |
|          2 | 2026-09-06 11:05:00    |
|          9 | 2026-09-07 10:35:00    |
|         17 | 2026-09-07 10:50:00    |
|          3 | 2026-09-07 12:05:00    |
|         18 | 2026-09-08 11:05:00    |
|         10 | 2026-09-08 11:35:00    |
|          4 | 2026-09-08 13:05:00    |
|         27 | 2026-09-08 13:35:00    |
|         31 | 2026-09-08 15:05:00    |
|         13 | 2026-09-09 09:35:00    |
|         19 | 2026-09-09 11:20:00    |
|          5 | 2026-09-09 14:05:00    |
|         29 | 2026-09-09 14:05:00    |
|         20 | 2026-09-10 11:35:00    |
|         21 | 2026-09-10 11:50:00    |
|         11 | 2026-09-10 12:35:00    |
|         24 | 2026-09-10 12:35:00    |
|         28 | 2026-09-10 13:50:00    |
|         30 | 2026-09-10 14:20:00    |
|          6 | 2026-09-10 15:05:00    |
|         32 | 2026-09-10 15:20:00    |
|          7 | 2026-09-10 16:05:00    |
+------------+------------------------+


-- ============================================================
-- 12. STRING MANIPULATION FUNCTIONS
-- ============================================================

-- 12.1 Convert all organizer names to uppercase.
SELECT
    organizer_id,
    UPPER(organizer_name) AS organizer_name_uppercase
FROM organizers;
+--------------+--------------------------+
| organizer_id | organizer_name_uppercase |
+--------------+--------------------------+
|            1 |   BRIGHT EVENTS INDIA    |
|            2 | FUTURE FEST TEAM         |
|            3 | TECHSPHERE ORGANIZERS    |
|            4 | CULTURAL CONNECT         |
|            5 | YOUTH INNOVATION CLUB    |
+--------------+--------------------------+

-- 12.2 Remove extra leading/trailing spaces from attendee names.
SELECT
    attendee_id,
    name AS original_name,
    TRIM(name) AS cleaned_name
FROM attendees;
+-------------+-----------------+--------------+
| attendee_id | original_name   | cleaned_name |
+-------------+-----------------+--------------+
|           1 |   Aisha Patel   | Aisha Patel  |
|           2 | Rahul Shah      | Rahul Shah   |
|           3 |   Neha Mehta    | Neha Mehta   |
|           4 | Karan Desai     | Karan Desai  |
|           5 |   Priya Joshi   | Priya Joshi  |
|           6 | Arjun Patel     | Arjun Patel  |
|           7 | Maya Trivedi    | Maya Trivedi |
|           8 | Dev Kumar       | Dev Kumar    |
|           9 | Riya Shah       | Riya Shah    |
|          10 |   Om Vora       | Om Vora      |
+-------------+-----------------+--------------+


-- 12.3 Replace NULL email fields with 'Not Provided'.
SELECT
    attendee_id,
    TRIM(name) AS attendee_name,
    COALESCE(email, 'Not Provided') AS email
FROM attendees;
+-------------+---------------+-------------------+
| attendee_id | attendee_name | email             |
+-------------+---------------+-------------------+
|           1 | Aisha Patel   | aisha@example.com |
|           2 | Rahul Shah    | rahul@example.com |
|           3 | Neha Mehta    | Not Provided      |
|           4 | Karan Desai   | karan@example.com |
|           5 | Priya Joshi   | Not Provided      |
|           6 | Arjun Patel   | arjun@example.com |
|           7 | Maya Trivedi  | maya@example.com  |
|           8 | Dev Kumar     | Not Provided      |
|           9 | Riya Shah     | riya@example.com  |
|          10 | Om Vora       | om@example.com    |
+-------------+---------------+-------------------+


-- ============================================================
-- 13. WINDOW FUNCTIONS
-- ============================================================

-- 13.1 Rank events based on total revenue.
WITH event_revenue AS (
    SELECT
        e.event_id,
        e.event_name,
        COALESCE(SUM(
            CASE WHEN p.payment_status = 'Success'
                 THEN p.amount_paid ELSE 0 END
        ), 0) AS total_revenue
    FROM events e
    LEFT JOIN tickets t ON e.event_id = t.event_id
    LEFT JOIN payments p ON t.ticket_id = p.ticket_id
    GROUP BY e.event_id, e.event_name
)
SELECT
    event_id,
    event_name,
    total_revenue,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM event_revenue
ORDER BY revenue_rank, event_id;
+----------+-------------------------------+---------------+--------------+
| event_id | event_name                    | total_revenue | revenue_rank |
+----------+-------------------------------+---------------+--------------+
|        1 | AI & Future Technology Summit |       9000.00 |            1 |
|        6 | FinTech Innovation Forum      |       8000.00 |            2 |
|        4 | Data Science Workshop         |       7000.00 |            3 |
|        2 | Startup Growth Conference     |       2400.00 |            4 |
|        8 | Leadership Excellence Seminar |       2200.00 |            5 |
|        7 | Digital Marketing Masterclass |       1800.00 |            6 |
|        5 | Music & Culture Night         |       1400.00 |            7 |
|        3 | Diwali Business Meetup        |        800.00 |            8 |
|        9 | Community Charity Walk        |          0.00 |            9 |
|       10 | Private Planning Workshop     |          0.00 |            9 |
+----------+-------------------------------+---------------+--------------+


-- 13.2 Cumulative sum of ticket sales.
WITH daily_sales AS (
    SELECT
        DATE(booking_date) AS booking_day,
        COUNT(*) AS tickets_sold
    FROM tickets
    WHERE status <> 'Cancelled'
    GROUP BY DATE(booking_date)
)
SELECT
    booking_day,
    tickets_sold,
    SUM(tickets_sold) OVER (
        ORDER BY booking_day
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_ticket_sales
FROM daily_sales
ORDER BY booking_day;
+-------------+--------------+-------------------------+
| booking_day | tickets_sold | cumulative_ticket_sales |
+-------------+--------------+-------------------------+
| 2026-09-01  |            1 |                       1 |
| 2026-09-02  |            1 |                       2 |
| 2026-09-04  |            2 |                       4 |
| 2026-09-05  |            3 |                       7 |
| 2026-09-06  |            3 |                      10 |
| 2026-09-07  |            3 |                      13 |
| 2026-09-08  |            5 |                      18 |
| 2026-09-09  |            4 |                      22 |
| 2026-09-10  |            9 |                      31 |
+-------------+--------------+-------------------------+


-- 13.3 Running total of attendees registered per event date.
WITH event_attendees AS (
    SELECT
        e.event_id,
        e.event_name,
        e.event_date,
        COUNT(CASE WHEN t.status <> 'Cancelled' THEN t.ticket_id END) AS attendees_registered
    FROM events e
    LEFT JOIN tickets t ON e.event_id = t.event_id
    GROUP BY e.event_id, e.event_name, e.event_date
)
SELECT
    event_id,
    event_name,
    event_date,
    attendees_registered,
    SUM(attendees_registered) OVER (
        ORDER BY event_date, event_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_attendee_total
FROM event_attendees
ORDER BY event_date, event_id;

+----------+-------------------------------+------------+----------------------+------------------------+
| event_id | event_name                    | event_date | attendees_registered | running_attendee_total |
+----------+-------------------------------+------------+----------------------+------------------------+
|        1 | AI & Future Technology Summit | 2026-09-20 |                    7 |                      7 |
|        2 | Startup Growth Conference     | 2026-10-05 |                    4 |                     11 |
|        9 | Community Charity Walk        | 2026-10-25 |                    0 |                     11 |
|        5 | Music & Culture Night         | 2026-11-14 |                    2 |                     13 |
|        3 | Diwali Business Meetup        | 2026-12-05 |                    2 |                     15 |
|        4 | Data Science Workshop         | 2026-12-18 |                    8 |                     23 |
|        6 | FinTech Innovation Forum      | 2026-12-20 |                    4 |                     27 |
|        7 | Digital Marketing Masterclass | 2027-01-15 |                    2 |                     29 |
|        8 | Leadership Excellence Seminar | 2027-02-10 |                    2 |                     31 |
|       10 | Private Planning Workshop     | 2027-03-15 |                    0 |                     31 |
+----------+-------------------------------+------------+----------------------+------------------------+

-- ============================================================
-- 14. CASE EXPRESSIONS
-- ============================================================

-- 14.1 Categorize events by ticket demand.
SELECT
    event_id,
    event_name,
    total_seats,
    available_seats,
    ROUND((available_seats / total_seats) * 100, 2) AS available_percentage,
    CASE
        WHEN available_seats < (0.20 * total_seats)
            THEN 'High Demand'
        WHEN available_seats BETWEEN (0.20 * total_seats)
                                  AND (0.50 * total_seats)
            THEN 'Moderate Demand'
        ELSE 'Low Demand'
    END AS demand_category
FROM events
ORDER BY available_percentage ASC;
+----------+-------------------------------+-------------+-----------------+----------------------+-----------------+
| event_id | event_name                    | total_seats | available_seats | available_percentage | demand_category |
+----------+-------------------------------+-------------+-----------------+----------------------+-----------------+
|        4 | Data Science Workshop         |         800 |             792 |                99.00 | Low Demand      |
|        6 | FinTech Innovation Forum      |         450 |             446 |                99.11 | Low Demand      |
|        5 | Music & Culture Night         |         350 |             347 |                99.14 | Low Demand      |
|        1 | AI & Future Technology Summit |        1000 |             993 |                99.30 | Low Demand      |
|        2 | Startup Growth Conference     |         600 |             596 |                99.33 | Low Demand      |
|        7 | Digital Marketing Masterclass |         800 |             796 |                99.50 | Low Demand      |
|        3 | Diwali Business Meetup        |         500 |             498 |                99.60 | Low Demand      |
|        8 | Leadership Excellence Seminar |         500 |             498 |                99.60 | Low Demand      |
|        9 | Community Charity Walk        |         350 |             350 |               100.00 | Low Demand      |
|       10 | Private Planning Workshop     |         450 |             450 |               100.00 | Low Demand      |
+----------+-------------------------------+-------------+-----------------+----------------------+-----------------+


-- 14.2 Assign payment status labels using CASE.
SELECT
    payment_id,
    ticket_id,
    payment_status,
    CASE
        WHEN payment_status = 'Success' THEN 'Successful'
        WHEN payment_status = 'Failed' THEN 'Failed'
        ELSE 'Pending'
    END AS payment_status_label
FROM payments;
+------------+-----------+----------------+----------------------+
| payment_id | ticket_id | payment_status | payment_status_label |
+------------+-----------+----------------+----------------------+
|          1 |         1 | Success        | Successful           |
|          2 |         2 | Success        | Successful           |
|          3 |         3 | Success        | Successful           |
|          4 |         4 | Success        | Successful           |
|          5 |         5 | Success        | Successful           |
|          6 |         6 | Success        | Successful           |
|          7 |         7 | Pending        | Pending              |
|          8 |         8 | Success        | Successful           |
|          9 |         9 | Success        | Successful           |
|         10 |        10 | Failed         | Failed               |
|         11 |        11 | Pending        | Pending              |
|         12 |        12 | Success        | Successful           |
|         13 |        13 | Refunded       | Pending              |
|         14 |        14 | Success        | Successful           |
|         15 |        15 | Success        | Successful           |
|         16 |        16 | Success        | Successful           |
|         17 |        17 | Success        | Successful           |
|         18 |        18 | Success        | Successful           |
|         19 |        19 | Success        | Successful           |
|         20 |        20 | Success        | Successful           |
|         21 |        21 | Pending        | Pending              |
|         22 |        22 | Success        | Successful           |
|         23 |        23 | Failed         | Failed               |
|         24 |        24 | Success        | Successful           |
|         25 |        25 | Success        | Successful           |
|         26 |        26 | Success        | Successful           |
|         27 |        27 | Success        | Successful           |
|         28 |        28 | Success        | Successful           |
|         29 |        29 | Success        | Successful           |
|         30 |        30 | Success        | Successful           |
|         31 |        31 | Success        | Successful           |
|         32 |        32 | Success        | Successful           |
+------------+-----------+----------------+----------------------+

-- ============================================================
-- 15. ADDITIONAL REPORTS / INSIGHTS
-- ============================================================

-- Most popular event.
SELECT
    e.event_id,
    e.event_name,
    COUNT(CASE WHEN t.status <> 'Cancelled' THEN t.ticket_id END) AS attendees
FROM events e
LEFT JOIN tickets t ON e.event_id = t.event_id
GROUP BY e.event_id, e.event_name
ORDER BY attendees DESC
LIMIT 1;
+----------+-----------------------+-----------+
| event_id | event_name            | attendees |
+----------+-----------------------+-----------+
|        4 | Data Science Workshop |         8 |

-- Highest revenue-generating event.
SELECT
    e.event_id,
    e.event_name,
    COALESCE(SUM(CASE WHEN p.payment_status = 'Success'
                      THEN p.amount_paid ELSE 0 END), 0) AS revenue
FROM events e
LEFT JOIN tickets t ON e.event_id = t.event_id
LEFT JOIN payments p ON t.ticket_id = p.ticket_id
GROUP BY e.event_id, e.event_name
ORDER BY revenue DESC
LIMIT 1;
| event_id | event_name                    | revenue |
+----------+-------------------------------+---------+
|        1 | AI & Future Technology Summit | 9000.00 |

-- Payment summary.
SELECT
    payment_status,
    COUNT(*) AS transaction_count,
    SUM(amount_paid) AS total_amount
FROM payments
GROUP BY payment_status
ORDER BY total_amount DESC;
+----------------+-------------------+--------------+
| payment_status | transaction_count | total_amount |
+----------------+-------------------+--------------+
| Success        |                26 |     32600.00 |
| Pending        |                 3 |      3700.00 |
| Failed         |                 2 |      1900.00 |
| Refunded       |                 1 |       800.00 |
+----------------+-------------------+--------------+

-- Event occupancy report.
SELECT
    event_id,
    event_name,
    total_seats,
    available_seats,
    total_seats - available_seats AS seats_booked,
    ROUND(((total_seats - available_seats) / total_seats) * 100, 2) AS occupancy_percentage
FROM events
ORDER BY occupancy_percentage DESC;
+----------+-------------------------------+-------------+-----------------+--------------+----------------------+
| event_id | event_name                    | total_seats | available_seats | seats_booked | occupancy_percentage |
+----------+-------------------------------+-------------+-----------------+--------------+----------------------+
|        4 | Data Science Workshop         |         800 |             792 |            8 |                 1.00 |
|        6 | FinTech Innovation Forum      |         450 |             446 |            4 |                 0.89 |
|        5 | Music & Culture Night         |         350 |             347 |            3 |                 0.86 |
|        1 | AI & Future Technology Summit |        1000 |             993 |            7 |                 0.70 |
|        2 | Startup Growth Conference     |         600 |             596 |            4 |                 0.67 |
|        7 | Digital Marketing Masterclass |         800 |             796 |            4 |                 0.50 |
|        3 | Diwali Business Meetup        |         500 |             498 |            2 |                 0.40 |
|        8 | Leadership Excellence Seminar |         500 |             498 |            2 |                 0.40 |
|        9 | Community Charity Walk        |         350 |             350 |            0 |                 0.00 |
|       10 | Private Planning Workshop     |         450 |             450 |            0 |                 0.00 |
+----------+-------------------------------+-------------+-----------------+--------------+----------------------+

-- ============================================================
-- END OF PROJECT
-- ============================================================

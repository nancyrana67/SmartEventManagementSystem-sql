


🎟️ Smart Event Management System — MySQL
A complete MySQL 8.0+ SQL project for managing events, venues, organizers, attendees, ticket bookings, payments, and event reports.

This project is designed to fulfill the requirements of the Smart Event Management System assignment, including:

CRUD operations

WHERE, HAVING, LIMIT

AND, OR, NOT

ORDER BY, GROUP BY

Aggregate functions: SUM, AVG, MAX, MIN, COUNT

Primary and foreign keys

INNER JOIN, LEFT JOIN, RIGHT JOIN, and MySQL-compatible FULL OUTER JOIN simulation

Subqueries

Date and time functions

String functions

Window functions

CASE expressions

Revenue and attendance reports

1. Project Objective
The objective is to develop a database-driven Smart Event Management System in MySQL where event organizers can:

Manage events and venues.

Handle attendee registrations and ticket sales.

Track successful, failed, pending, and refunded payments.

Generate useful reports such as the most popular event and highest revenue-generating event.

Demonstrate important SQL concepts required for the assignment.

2. Problem Statement
The system allows event organizers to:

Add, update, delete, and search events.

Manage venues and organizers.

Register attendees.

Book, modify, and cancel tickets.

Track payment status.

Calculate event revenue.

Find popular and high-revenue events.

Analyze event dates and ticket demand.

Generate advanced SQL reports.

3. Database Schema
The database is named:

smart_event_management
It contains 6 tables:

                    ┌──────────────────┐
                    │      VENUES      │
                    │──────────────────│
                    │ PK venue_id      │
                    │ venue_name       │
                    │ location         │
                    │ capacity         │
                    └────────┬─────────┘
                             │ 1
                             │
                             │ N
                    ┌────────▼─────────┐
                    │      EVENTS      │
                    │──────────────────│
                    │ PK event_id      │
                    │ event_name       │
                    │ event_date       │
                    │ FK venue_id      │
                    │ FK organizer_id  │
                    │ ticket_price     │
                    │ total_seats      │
                    │ available_seats  │
                    └───────┬──────────┘
                            │
                 ┌──────────┴───────────┐
                 │                      │
                1│                     N│
        ┌────────▼────────┐    ┌────────▼────────┐
        │   ORGANIZERS    │    │     TICKETS     │
        │─────────────────│    │─────────────────│
        │ PK organizer_id │    │ PK ticket_id    │
        │ organizer_name  │    │ FK event_id     │
        │ contact_email   │    │ FK attendee_id  │
        │ phone_number    │    │ booking_date    │
        └─────────────────┘    │ status          │
                               └───────┬─────────┘
                                       │ 1
                                       │
                                       │ N
                               ┌───────▼─────────┐
                               │    PAYMENTS     │
                               │─────────────────│
                               │ PK payment_id   │
                               │ FK ticket_id    │
                               │ amount_paid     │
                               │ payment_status  │
                               │ payment_date    │
                               └─────────────────┘

                    ┌──────────────────┐
                    │    ATTENDEES     │
                    │──────────────────│
                    │ PK attendee_id   │
                    │ name             │
                    │ email            │
                    │ phone_number     │
                    └────────┬─────────┘
                             │ 1
                             │
                             │ N
                         TICKETS
Relationship summary
Relationship	Type	Description
Venues → Events	1	One venue can host many events
Organizers → Events	1	One organizer can manage many events
Events → Tickets	1	One event can have many ticket bookings
Attendees → Tickets	1	One attendee can book multiple different events
Tickets → Payments	1	A ticket can have payment transaction records
Important business rule
An attendee cannot book the same event more than once.

This is enforced by:

UNIQUE (event_id, attendee_id)
Therefore, the database itself prevents duplicate event bookings.

4. Table Details
4.1 venues
Stores information about event venues.

Column	Type	Key	Description
venue_id	INT	PK	Unique venue ID
venue_name	VARCHAR(100)	
Venue name
location	VARCHAR(100)	
City/location
capacity	INT	
Maximum capacity
4.2 organizers
Stores event organizer information.

Column	Type	Key	Description
organizer_id	INT	PK	Unique organizer ID
organizer_name	VARCHAR(100)	
Organizer name
contact_email	VARCHAR(150)	
Email address
phone_number	VARCHAR(20)	
Phone number
4.3 attendees
Stores people attending events.

Column	Type	Key	Description
attendee_id	INT	PK	Unique attendee ID
name	VARCHAR(100)	
Attendee name
email	VARCHAR(150)	
Email address
phone_number	VARCHAR(20)	
Phone number
Some sample names intentionally contain extra spaces so that TRIM() can be demonstrated.

Some sample email values are NULL so that COALESCE() can demonstrate "Not Provided".

4.4 events
Stores the main event information.

Column	Type	Key	Description
event_id	INT	PK	Unique event ID
event_name	VARCHAR(150)	
Event name
event_date	DATE	
Event date
venue_id	INT	FK	References venues
organizer_id	INT	FK	References organizers
ticket_price	DECIMAL(10,2)	
Price of one ticket
total_seats	INT	
Total seats
available_seats	INT	
Remaining seats
4.5 tickets
Stores ticket bookings.

Column	Type	Key	Description
ticket_id	INT	PK	Unique ticket ID
event_id	INT	FK	References events
attendee_id	INT	FK	References attendees
booking_date	DATETIME	
Date/time of booking
status	ENUM	
Confirmed, Cancelled, Pending
4.6 payments
Stores payment transactions.

Column	Type	Key	Description
payment_id	INT	PK	Unique payment ID
ticket_id	INT	FK	References tickets
amount_paid	DECIMAL(10,2)	
Amount paid
payment_status	ENUM	
Success, Failed, Pending, Refunded
payment_date	DATETIME	
Date/time of payment
5. SQL Requirements Covered
5.1 CRUD Operations
The project includes examples for:

Create / INSERT

Read / SELECT

Update / UPDATE

Delete / DELETE

Search using LIKE

CRUD can be applied to:

Events

Venues

Organizers

Attendees

Ticket bookings

The SQL script contains a safe demonstration for database operations and commented templates for additional CRUD operations.

6. SQL Clauses
WHERE
Used to filter records.

Example:

SELECT *
FROM events
WHERE event_date >= CURDATE();
HAVING
Used to filter grouped results.

Example:

SELECT organizer_id, COUNT(*) AS event_count
FROM events
GROUP BY organizer_id
HAVING COUNT(*) > 3;
LIMIT
Used to return a fixed number of records.

Example:

SELECT *
FROM events
ORDER BY event_date
LIMIT 5;
7. SQL Operators
The project demonstrates:

AND
Find December events with more than 50% available seats.

OR
Find attendees who booked a ticket OR have a pending payment.

NOT
Find events that are NOT fully booked.

8. Sorting and Grouping
ORDER BY
Events can be sorted by event date:

ORDER BY event_date ASC;
GROUP BY
Attendees can be counted per event:

GROUP BY e.event_id, e.event_name;
Revenue can also be grouped by event.

9. Aggregate Functions
The project uses all required aggregate functions:

Function	Purpose
SUM()	Total revenue
AVG()	Average ticket price
MAX()	Highest ticket price
MIN()	Lowest ticket price
COUNT()	Number of events/attendees/tickets
Example:

SELECT
    SUM(amount_paid) AS total_revenue,
    MAX(amount_paid) AS maximum_payment,
    MIN(amount_paid) AS minimum_payment,
    AVG(amount_paid) AS average_payment,
    COUNT(*) AS total_transactions
FROM payments
WHERE payment_status = 'Success';
10. Primary and Foreign Keys
Primary keys uniquely identify records.

Examples:

venues.venue_id
organizers.organizer_id
attendees.attendee_id
events.event_id
tickets.ticket_id
payments.payment_id
Foreign keys connect the tables.

Examples:

events.venue_id → venues.venue_id
events.organizer_id → organizers.organizer_id
tickets.event_id → events.event_id
tickets.attendee_id → attendees.attendee_id
payments.ticket_id → tickets.ticket_id
11. Joins
The project demonstrates all joins requested in the assignment.

INNER JOIN
Event details with venue information.

LEFT JOIN
Attendees who booked a ticket but did not complete successful payment.

RIGHT JOIN
Events that do not have any attendees.

FULL OUTER JOIN
MySQL does not directly support FULL OUTER JOIN.

Therefore, it is simulated using:

LEFT JOIN
UNION
RIGHT JOIN
The complete query is included in event_management.sql.

12. Subqueries
The project includes:

1. Events above average revenue
The average revenue is calculated in a subquery and events above that average are displayed.

2. Attendees with multiple event bookings
Uses grouping and a subquery-style analytical requirement to identify attendees booking more than one event.

3. Organizers managing more than 3 events
Uses GROUP BY and HAVING.

13. Date and Time Functions
The following MySQL functions are used:

MONTH()
Extracts the month from an event date.

MONTH(event_date)
MONTHNAME()
Returns the month name.

MONTHNAME(event_date)
DATEDIFF()
Calculates days remaining:

DATEDIFF(event_date, CURDATE())
DATE_FORMAT()
Formats payment date:

DATE_FORMAT(payment_date, '%Y-%m-%d %H:%i:%s')
Output format:

YYYY-MM-DD HH:MM:SS
14. String Functions
UPPER()
Converts organizer names to uppercase.

UPPER(organizer_name)
TRIM()
Removes leading and trailing spaces.

TRIM(name)
COALESCE()
Replaces NULL email values:

COALESCE(email, 'Not Provided')
15. Window Functions
This is one of the most important parts of the project.

RANK()
Ranks events according to revenue:

RANK() OVER (ORDER BY total_revenue DESC)
Running/Cumulative Sum
SUM(tickets_sold) OVER (
    ORDER BY booking_day
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)
Running Total of Attendees
The script calculates attendees registered for each event and then produces a running total ordered by event date.

16. CASE Expressions
Event Demand Category
The project follows the assignment rules:

Available seats < 20% of total seats
        → High Demand

Available seats between 20% and 50%
        → Moderate Demand

Otherwise
        → Low Demand
Implemented using:

CASE
    WHEN available_seats < (0.20 * total_seats)
        THEN 'High Demand'
    WHEN available_seats BETWEEN (0.20 * total_seats)
                              AND (0.50 * total_seats)
        THEN 'Moderate Demand'
    ELSE 'Low Demand'
END
Payment Status
Success → Successful
Failed  → Failed
Other   → Pending
The script also stores Refunded transactions to satisfy the project objective of tracking refunds.

17. Reports and Insights
The database also generates useful business reports.

Most Popular Event
The event with the highest number of registered attendees.

Highest Revenue Event
The event with the highest successful payment revenue.

Payment Summary
Shows:

Number of transactions

Total amount

Payment status

Occupancy Report
Shows:

Total seats

Available seats

Seats booked

Occupancy percentage

18. Sample Data Design
The sample data is deliberately designed to test all requirements.

It includes:

Multiple venues

Multiple organizers

Multiple attendees

Events in different months

December events

Events with no attendees

Multiple event bookings by some attendees

Pending payments

Failed payments

Refunded payment

Successful payments

Attendee names with extra spaces

Attendees with NULL emails

An organizer managing more than 3 events

Recent bookings for the last-7-days query

This means the queries are not just theoretical; they have suitable data to demonstrate the required SQL concepts.

19. How to Run the Project
Option 1: MySQL Workbench
Install MySQL 8.0+ and MySQL Workbench.

Open MySQL Workbench.

Open:

event_management.sql
Connect to your MySQL server.

Execute the complete script.

The script automatically creates:

smart_event_management
Refresh the Schemas panel.

Open the database and inspect the six tables.

Option 2: MySQL Command Line
Run:

mysql -u root -p < event_management.sql
Then enter your MySQL password.

20. Project File Structure
smart-event-management/
│
├── event_management.sql
└── README.md
event_management.sql
Contains:

Database creation

Table creation

Constraints

Indexes

Sample data

CRUD queries

Filtering

Operators

Sorting

Grouping

Aggregates

Joins

Subqueries

Date/time functions

String functions

Window functions

CASE expressions

Reports

README.md
Contains:

Project objective

Problem statement

Schema

Relationships

Table descriptions

SQL concepts

How to run

Project structure

21. Technologies Used
Database: MySQL

SQL Version: MySQL 8.0+

Tool: MySQL Workbench / MySQL CLI

Language: SQL

22. Learning Outcomes
After completing this project, the following SQL concepts are demonstrated:

Database and table creation

Primary keys

Foreign keys

Unique constraints

Check constraints

Insert, update, delete and select

Filtering

Sorting

Grouping

Aggregate functions

Multiple types of joins

Subqueries

Date/time functions

String manipulation

Window functions

CASE expressions

Business reporting

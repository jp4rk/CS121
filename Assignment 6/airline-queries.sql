-- [Problem 6a]
SELECT purchase_date, flight_date, last_name, first_name
    FROM (SELECT purchase_id, purchase_date 
    FROM purchase WHERE customer_id = 54321) AS x NATURAL JOIN ticket
    NATURAL JOIN ticket_info NATURAL JOIN customer
    ORDER BY purcahse_date DESC, flight_date, last_name, first_name;


-- [Problem 6b]
SELECT type_code, SUM(ticket_price) AS revenue FROM airplane NATURAL JOIN
flight NATURAL JOIN ticket_info NATURAL JOIN ticket WHERE 
TIMESTAMP(flight_date, flight_time) 
BETWEEN NOW() - INTERVAL 2 WEEK AND NOW() GROUP BY aircraft_code;

-- [Problem 6c]
SELECT customer_id, first_name, last_name, email 
FROM customer NATURAL JOIN traveler NATURAL JOIN 
ticket NATURAL JOIN ticket_info NATURAL JOIN flight
WHERE !is_domestic AND (ISNULL(passport_num) OR ISNULL(country) OR
ISNULL(emergency_name) OR ISNULL(emergency_contact));



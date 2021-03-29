-- [Problem 5]

-- DROP TABLE commands:

DROP TABLE IF EXISTS ticket_info;
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS traveler;
DROP TABLE IF EXISTS purchaser;
DROP TABLE IF EXISTS customer_phone;
DROP TABLE IF EXISTS flight, seat;
DROP TABLE IF EXISTS airplane, customer;

-- CREATE TABLE commands:
-- This table stores informatino about the airplane. 
-- type_code is IATA aircraft type code. Note that
-- Note that combining company and model will represent unique airplane model.
CREATE TABLE airplane (
    type_code CHAR(3) PRIMARY KEY,
    company VARCHAR(30) NOT NULL, 
    model VARCHAR(10) NOT NULL,
    UNIQUE (company, model) 
);

-- This table stores informatino about the customers, where 
-- customer_id, their full name (divided into first and last),
-- and emaill address is given. 

CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL, 
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL
);



-- This table stores information about the flight. sour_airport and 
-- dest_airport are aircodes represented in 3 letter IATA. If is_domestic
-- is true, then it's domestic; else, it's international. The combination of 
-- flight number and date will uniquely identify each flight. 

CREATE TABLE flight (
    flight_num VARCHAR(8),
    flight_date DATE,
    flight_time TIME NOT NULL,
    sour_airport CHAR(3) NOT NULL,
    dest_airport CHAR(3) NOT NULL,
    is_domestic BOOLEAN NOT NULL,
    type_code CHAR(3) NOT NULL UNIQUE,
    PRIMARY KEY (flight_num, flight_date),
    FOREIGN KEY (type_code) REFERENCES airplane(type_code)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table stores information about the seat. seat_class is represented
-- in one letter (e.g. First class would be "F"). Flag_exit means if the 
-- seat is an exit row. 

CREATE TABLE seat (
    seat_num VARCHAR(4) PRIMARY KEY,
    type_code CHAR(3) PRIMARY KEY,
    seat_class CHAR(1) NOT NULL,
    seat_type CHAR(1) NOT NULL,
    flag_exit BOOLEAN NOT NULL,
    FOREIGN KEY (type_code) REFERENCES airplane(type_code)
         ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table stores information about the customer's phone.

CREATE TABLE customer_phone (
    customer_id SERIAL,
    phone_num CHAR(12),
    PRIMARY KEY (customer_id, phone_num),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
    
);

-- This table stores information about purchasers.

CREATE TABLE purchaser (
    customer_id SERIAL PRIMARY KEY,
    card_num CHAR(16),
    exp_date CHAR(5),
    ver_code CHAR(3),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table stores information about travelers. Note that 
-- passport number and country of citizenship will uniquely 
-- identify each purchasers.

CREATE TABLE traveler (
    customer_id SERIAL PRIMARY KEY,
    passport_num CHAR(16) KEY,
    country VARCHAR(50) KEY,
    emergency_name VARCHAR(50) KEY,
    emergency_contact VARCHAR(20) KEY,
    freq_fly_num CHAR(7) KEY,
    
    UNIQUE(passport_num, country),

    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table stores information about purcahses. 

CREATE TABLE purchase (
    purchase_id SERIAL PRIMARY KEY,
    purcahse_date TIMESTAMP NOT NULL,
    confirm_num CHAR(6) NOT NULL UNIQUE,
    customer_id BIGINT UNSIGNED KEY NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES purchaser(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table stores general information about the ticket. 

CREATE TABLE ticket (
    ticket_id SERIAL PRIMARY KEY,
    ticket_price NUMERIC(6, 2) NOT NULL,
    purchase_id BIGINT UNSIGNED KEY NOT NULL,
    customer_id BIGINT UNSIGNED KEY NOT NULL,

    FOREIGN KEY (purcahse_id) REFERENCES purchaser(purchase_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES traveler(customer_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- This table stores specific information about the ticket, specifically
-- for each individual. 

CREATE TABLE ticket_info (
    flight_num VARCHAR(8),
    flight_date DATE,
    type_code CHAR(3),
    seat_num VARCHAR(4),
    ticket_id BIGINT UNSIGNED KEY UNIQUE,
    
    PRIMARY KEY (flight_num, flight_date, type_code, seat_num),

    FOREIGN KEY (flight_num) REFERENCES flight(flight_num)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (flight_date) REFERENCES flight(flight_date)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (type_code) REFERENCES flight(type_code)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (seat_num) REFERENCES seat(seat_num)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ticket_id) REFERENCES ticket(ticket_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);






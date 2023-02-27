CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR (45) NOT NULL,
	last_name 	VARCHAR (45) NOT NULL
);

INSERT INTO customers (
	first_name,
	last_name 
)VALUES(
	'Alex',
	'Cross'
),(
	'Matt',
	'Tekking'
);

CREATE TABLE sales_staff(
	sstaff_id SERIAL PRIMARY KEY,
	first_name VARCHAR (45) NOT NULL,
	last_name 	VARCHAR (45) NOT NULL
);

INSERT INTO sales_staff(
	first_name,
	last_name 
)VALUES(
	'Joey',
	'Anime'
),(
	'Garnt',
	'Gigguk'
);

CREATE TABLE mechanics(
	mechanic_id SERIAL PRIMARY KEY,
	first_name VARCHAR (45) NOT NULL,
	last_name 	VARCHAR (45) NOT NULL
);

INSERT INTO mechanics(
	first_name,
	last_name 
)VALUES(
	'Gerard',
	'Way'
),(
	'Marshal',
	'Mathers'
);

CREATE TABLE customer_vehicle(
	vehicle_id SERIAL PRIMARY KEY,
	VIN VARCHAR (17) NOT NULL UNIQUE,
	make VARCHAR (45) NOT NULL,
	model VARCHAR (45) NOT NULL,
	package_id VARCHAR (45) NOT NULL,
	color VARCHAR (45) NOT NULL,
	model_year integer NOT NULL,
	customer_id integer NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customer_vehicle(
	VIN,
	make,
	model,
	package_id,
	color,
	model_year,
	customer_id 
)VALUES(
	'123456ABC78DE90FG',
	'Ford',
	'Mustang',
	'GT',
	'Blue',
	2005,
	1
),(
	'ABCD1234EFGH5678I',
	'Toyota',
	'Celica',
	'GT',
	'Green',
	2010,
	2
);

CREATE TABLE vehicle_inventory(
	inventory_id SERIAL PRIMARY KEY,
	VIN VARCHAR (17) NOT NULL UNIQUE,
	make VARCHAR (45) NOT NULL,
	model VARCHAR (45) NOT NULL,
	package_id VARCHAR (45) NOT NULL,
	color VARCHAR (45) NOT NULL,
	model_year integer NOT NULL,
	customer_id integer NOT NULL,
	is_new BOOLEAN NOT NULL
);

INSERT INTO vehicle_inventory (
	VIN,
	make,
	model,
	package_id,
	color,
	model_year,
	customer_id,
	is_new 
)VALUES(
	'123456ABC78DE90gg',
	'Nissan',
	'Skyline',
	'GTR',
	'Blue',
	1996,
	0,
	False
),(
	'ABCD1234345H5678I',
	'Toyota',
	'Corolla',
	'GS',
	'White',
	2022,
	0,
	True
);

CREATE TABLE invoices (
	invoice_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	sstaff_id INTEGER NOT NULL,
	VIN VARCHAR (17) NOT NULL,
	price FLOAT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (sstaff_id) REFERENCES sales_staff(sstaff_id),
	FOREIGN KEY (VIN) REFERENCES vehicle_inventory(VIN)
);

INSERT INTO invoices (
	customer_id,
	sstaff_id,
	VIN,
	price 
)VALUES(
	1,
	1,
	'123456ABC78DE90gg',
	133754.17
),(
	2,
	2,
	'ABCD1234345H5678I',
	23000.45
);

CREATE TABLE customer_service_tickets (
	ticket_id SERIAL PRIMARY KEY,
	VIN VARCHAR (17) NOT NULL,
	customer_id INTEGER NOT NULL,
	price FLOAT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (VIN) REFERENCES customer_vehicle(VIN)
);

INSERT INTO customer_service_tickets (
	VIN,
	customer_id ,
	price 
)VALUES(
	'123456ABC78DE90FG',
	1,
	234.43
),(
	'ABCD1234EFGH5678I',
	2,
	2354.45
);

CREATE TABLE internal_service_tickets (
	ticket_id SERIAL PRIMARY KEY,
	VIN VARCHAR (17) NOT NULL,
	FOREIGN KEY (VIN) REFERENCES vehicle_inventory(VIN)
);

INSERT INTO internal_service_tickets (
	vin
)VALUES(
	'123456ABC78DE90gg'
),(
	'123456ABC78DE90gg'
);

CREATE TABLE mechanic_service (
	mechanic_service_id SERIAL PRIMARY KEY,
	ticket_id INTEGER NOT NULL,
	mechanic_id INTEGER NOT NULL,
	FOREIGN KEY (ticket_id) REFERENCES customer_service_tickets(ticket_id),
	FOREIGN KEY (mechanic_id) REFERENCES mechanics(mechanic_id)
);

CREATE OR REPLACE PROCEDURE insertMechService(
	tid integer,
	mechid integer
)
LANGUAGE plpgsql AS $$
BEGIN 
	INSERT INTO mechanic_service (
		ticket_id,
		mechanic_id
	)VALUES(
		tid,
		mechid
	);
	COMMIT;
END;
$$

CALL insertmechservice(1, 2);
CALL insertmechservice(2, 2);

CREATE TABLE internal_mechanic_service (
	mechanic_service_id SERIAL PRIMARY KEY,
	ticket_id INTEGER NOT NULL,
	mechanic_id INTEGER NOT NULL,
	FOREIGN KEY (ticket_id) REFERENCES internal_service_tickets(ticket_id),
	FOREIGN KEY (mechanic_id) REFERENCES mechanics(mechanic_id)
);
CREATE OR REPLACE PROCEDURE insertIntMechService(
	tid integer,
	mechid integer
)
LANGUAGE plpgsql AS $$
BEGIN 
	INSERT INTO internal_mechanic_service (
		ticket_id,
		mechanic_id
	)VALUES(
		tid,
		mechid
	);
	COMMIT;
END;
$$

CALL insertmechservice(1, 1);
CALL insertmechservice(2, 1);


CREATE TABLE customer_service_records (
	record_id SERIAL PRIMARY KEY,
	VIN VARCHAR (17) NOT NULL,
	ticket_id INTEGER NOT NULL,
	FOREIGN KEY (VIN) REFERENCES customer_vehicle(VIN),
	FOREIGN KEY (ticket_id) REFERENCES customer_service_tickets(ticket_id)
);

INSERT INTO customer_service_records (
	vin,
	ticket_id
)VALUES(
	'123456ABC78DE90FG',
	1
),(
	'ABCD1234EFGH5678I',
	2
);

CREATE TABLE internal_service_records (
	record_id SERIAL PRIMARY KEY,
	VIN VARCHAR (17) NOT NULL,
	ticket_id INTEGER NOT NULL,
	FOREIGN KEY (VIN) REFERENCES vehicle_inventory(VIN),
	FOREIGN KEY (ticket_id) REFERENCES internal_service_tickets(ticket_id)
);

INSERT INTO internal_service_records (
	vin,
	ticket_id
)VALUES(
	'123456ABC78DE90gg',
	1
),(
	'123456ABC78DE90gg',
	2
);

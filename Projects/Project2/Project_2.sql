CREATE TABLE profession (
    prof_id bigserial PRIMARY KEY,  
    profession varchar(25) UNIQUE  
);


INSERT INTO profession (profession)
	VALUES
	('Developer'), -- id 1
	('Teacher'), -- id 2
	('Author'), -- id 3
	('Cashier'), -- id 4
	('Biologist'); -- id 5

SELECT * FROM profession;


CREATE TABLE zip_code (
    zip_code char(5) PRIMARY KEY CHECK (zip_code ~ '^[0-9]{5}$'), 
    city varchar(50),  
    state varchar(30)  
);

INSERT INTO zip_code (zip_code, city, state) 
	VALUES
	('96701', 'Honolulu', 'Hawaii'),
	('03091', 'Augusta', 'Maine'),
	('37010', 'Nashville', 'Tenessee'),
	('46001', 'Indianapolis', 'Indiana'),
	('73301', 'Austin', 'Texas');

SELECT * FROM zip_code;


CREATE TABLE status (
    status_id bigserial PRIMARY KEY,
    status varchar(15)  
);

INSERT INTO status (status)
	VALUES
	('Single'), -- id 1
	('Looking'), -- id 2
	('Taken'), -- id 3
	('Married'), -- id 4
	('Complicated'); -- id 5

SELECT * FROM status;


CREATE TABLE interests (
    interest_id bigserial PRIMARY KEY,  
    interest varchar(25)  
);

INSERT INTO interests (interest)
	VALUES
	('Reading'), -- id 1
	('Art'), -- id 2
	('Gaming'), -- id 3
	('Hiking'), -- id 4
	('Oh my gosh, an interest'); -- id 5

SELECT * FROM interests;


CREATE TABLE seeking (
    seeking_id bigserial PRIMARY KEY,  
    seeking varchar(20)           
);

INSERT INTO seeking (seeking) 
	VALUES
	('Friends'), -- id 1
	('Relationship'), -- id 2
	('Mentor'), -- id 3
	('Casual'), -- id 4
	('Networking'); -- id 5

SELECT * FROM seeking;


CREATE TABLE my_contacts (
    contact_id bigserial PRIMARY KEY,  
    last_name varchar(50),  
    first_name varchar(25),  
    phone varchar(30),  
    email varchar(50),  
    gender varchar(10),  
    birthday date,  
    prof_id bigint REFERENCES profession(prof_id),  
    zip_code char(5) REFERENCES zip_code(zip_code),  
    status_id bigint REFERENCES status(status_id)  
);

INSERT INTO my_contacts (last_name, first_name, phone, email, gender, birthday, prof_id, zip_code, status_id)
	VALUES
	('Doe', 'John', '+27 84 432 2954', 'john.doe@example.com', 'male', '1980-01-30', 3, '73301', 5),
	('Smith', 'Jerry', '+27 84 432 2954', 'jerry.smith@example.com', 'male', '1996-06-22', 1, '46001', 1),
	('Dunst', 'Erica', '+27 84 432 2954', 'erica.dunst@example.com', 'female', '1988-01-12', 2, '03091', 4),
	('Waltz', 'Roe', '+27 84 432 2954', 'roe.waltz@example.com', 'nonbinary', '1992-04-18', 5, '96701', 2),
	('Champh', 'Henry', '+27 84 432 2954', 'henry.champh@example.com', 'male', '2001-08-15', 4, '37010', 3);

SELECT * FROM my_contacts;


CREATE TABLE contact_interest (
    contact_id bigint REFERENCES my_contacts(contact_id) ON DELETE CASCADE,
    interest_id bigint REFERENCES interests(interest_id) ON DELETE CASCADE,  
    PRIMARY KEY (contact_id, interest_id) 
);

INSERT INTO contact_interest (contact_id, interest_id)
	VALUES
	(1, 1),
	(1, 4),
	(2, 3),
	(3, 4),
	(3, 2),
	(4, 2),
	(4, 3),
	(4, 5),
	(5, 5);

-- ('Friends'), -- id 1
-- ('Relationship'), -- id 2
-- ('Mentor'), -- id 3
-- ('Casual'), -- id 4
-- ('Networking'); -- id 5

SELECT * FROM contact_interest;


CREATE TABLE contact_seeking (
    contact_id bigint REFERENCES my_contacts(contact_id) ON DELETE CASCADE,
    seeking_id bigint REFERENCES seeking(seeking_id) ON DELETE CASCADE, 
    PRIMARY KEY (contact_id, seeking_id)
);

INSERT INTO contact_seeking (contact_id, seeking_id)
	VALUES
	(1, 1),
	(2, 1),
	(2, 3),
	(3, 1),
	(4, 5),
	(4, 2),
	(5, 4),
	(1, 4);

SELECT * FROM contact_seeking;


SELECT 
    contact.first_name,
    contact.last_name,
    prof.profession,
    zip.zip_code,
    zip.city,
    zip.state,
    s.status,
    STRING_AGG(DISTINCT inter.interest, ', ' ORDER BY inter.interest) AS interests,
    STRING_AGG(DISTINCT seek.seeking, ', ' ORDER BY seek.seeking) AS seeking_types
FROM my_contacts as contact
LEFT JOIN profession as prof ON contact.prof_id = prof.prof_id
LEFT JOIN zip_code as zip ON contact.zip_code = zip.zip_code
LEFT JOIN status as s ON contact.status_id = s.status_id
LEFT JOIN contact_interest as cont_i ON contact.contact_id = cont_i.contact_id
LEFT JOIN interests as inter ON cont_i.interest_id = inter.interest_id
LEFT JOIN contact_seeking as cont_s ON contact.contact_id = cont_s.contact_id
LEFT JOIN seeking as seek ON cont_s.seeking_id = seek.seeking_id
GROUP BY 
    contact.contact_id,
    contact.first_name,
    contact.last_name,
    prof.profession,
    zip.zip_code,
    zip.city,
    zip.state,
    s.status;
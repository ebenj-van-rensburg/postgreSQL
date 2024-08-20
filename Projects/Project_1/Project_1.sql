CREATE TABLE Department (
    depart_id bigserial PRIMARY KEY,
    depart_name character varying(100),
    depart_city character varying(100)
);

INSERT INTO Department (depart_name, depart_city) 
VALUES 
	('HR', 'Chicago'), 
	('Development', 'San Francisco'),
	('Sales', 'Huston');

SELECT * FROM Department;

CREATE TABLE Roles (
    role_id bigserial PRIMARY KEY,
    role character varying(100)
);

INSERT INTO Roles (role) 
VALUES 
	('Junior Dev'), 
	('Sales'),
	('Senior Dev'),
	('HR'),
	('Manager');

SELECT * FROM Roles;

CREATE TABLE Salaries (
    salary_id bigserial PRIMARY KEY,
    salary_pa bigint
);

INSERT INTO Salaries (salary_pa) 
VALUES 
	(15000),
	(20000),
	(50000), 
	(80000), 
	(100000);

SELECT * FROM Salaries;

CREATE TABLE Overtime_Hours (
    overtime_id bigserial PRIMARY KEY,
    overtime_hours bigint
);

INSERT INTO Overtime_Hours (overtime_hours) 
VALUES 
	(2), 
	(5), 
	(10);

SELECT * FROM Overtime_Hours;

CREATE TABLE Employees (
    emp_id bigserial PRIMARY KEY,
    first_name character varying(15),
    surname character varying(20),
    gender character varying(10),
    address character varying(30),
    email character varying(100) UNIQUE,
	depart_id INT,
    role_id INT,
    salary_id INT,
    overtime_id INT,
    FOREIGN KEY (depart_id) REFERENCES Department(depart_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (salary_id) REFERENCES Salaries(salary_id),
    FOREIGN KEY (overtime_id) REFERENCES Overtime_Hours(overtime_id)
);

INSERT INTO Employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id) 
VALUES 
	('Jacob', 'Rainer', 'Male', '456 Altman Avenue', 'john.doe@example.com', 2, 1, 1, 1),
	('Delores', 'Smith', 'Female', '123 During Road', 'jane.smith@example.com', 2, 3, 3, 2);

SELECT * FROM Employees;

-- Left Join Function 
SELECT 
    e.first_name, 
    e.surname, 
    d.depart_name, 
    r.role, 
    s.salary_pa, 
    o.overtime_hours
FROM 
    Employees e
LEFT JOIN 
    Department d ON e.depart_id = d.depart_id
LEFT JOIN 
    Roles r ON e.role_id = r.role_id
LEFT JOIN 
    Salaries s ON e.salary_id = s.salary_id
LEFT JOIN 
    Overtime_Hours o ON e.overtime_id = o.overtime_id;
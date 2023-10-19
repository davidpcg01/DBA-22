--DROP TABLE IF EXISTS
DROP TABLE IF EXISTS product1_account;
DROP TABLE IF EXISTS product2_account;
DROP TABLE IF EXISTS product3_account;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS repair_accidents;
DROP TABLE IF EXISTS production_accidents;
DROP TABLE IF EXISTS accident;
DROP TABLE IF EXISTS repair;
DROP TABLE IF EXISTS constraints;
DROP TABLE IF EXISTS technical_staff_degree;
DROP TABLE IF EXISTS product1;
DROP TABLE IF EXISTS product2;
DROP TABLE IF EXISTS product3;
DROP TABLE IF EXISTS complaints;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS technical_staff;
DROP TABLE IF EXISTS quality_controller;
DROP TABLE IF EXISTS worker;
DROP TABLE IF EXISTS employee;



--CREATE TABLES
CREATE TABLE employee (
    name VARCHAR(64) PRIMARY KEY,
    address VARCHAR(64),
    salary REAL
);

CREATE TABLE technical_staff (
    name VARCHAR(64) PRIMARY KEY,
    technical_position VARCHAR(64)

    CONSTRAINT FK_tname FOREIGN KEY (name) REFERENCES employee
);

CREATE TABLE technical_staff_degree (
    name VARCHAR(64),
    degree VARCHAR(64)

    PRIMARY KEY (name, degree)
    CONSTRAINT FK_tsname FOREIGN KEY (name) REFERENCES technical_staff
    CONSTRAINT degree_check CHECK (degree IN ('BSC', 'MSC', 'PHD'))

);

CREATE TABLE quality_controller (
    name VARCHAR(64) PRIMARY KEY,
    product_type VARCHAR(64)

    CONSTRAINT FK_qcname FOREIGN KEY (name) REFERENCES employee
    CONSTRAINT producttype_check CHECK (product_type IN ('product1', 'product2', 'product3'))
);

CREATE TABLE worker (
    name VARCHAR(64) PRIMARY KEY,
    max_products_per_day INT

    CONSTRAINT FK_wname FOREIGN KEY (name) REFERENCES employee
);


CREATE TABLE products (
    pID VARCHAR(64) PRIMARY KEY,
    production_date DATE,
    creation_time VARCHAR(64),
    produced_by VARCHAR(64) NOT NULL,
    tested_by VARCHAR(64) NOT NULL,
    repaired_by VARCHAR(64)

    CONSTRAINT FK_produced_by FOREIGN KEY (produced_by) REFERENCES worker,
    CONSTRAINT FK_tested_by FOREIGN KEY (tested_by) REFERENCES quality_controller,
    CONSTRAINT FK_repaired_by FOREIGN KEY (repaired_by) REFERENCES technical_staff
);


CREATE TABLE product1 (
    pID VARCHAR(64) PRIMARY KEY,
    size VARCHAR(64),
    major_software VARCHAR(64)

    CONSTRAINT FK_pID1 FOREIGN KEY (pID) REFERENCES products,
    CONSTRAINT p1_size_check CHECK (size IN ('small', 'medium', 'large'))
);

CREATE TABLE product2 (
    pID VARCHAR(64) PRIMARY KEY,
    size VARCHAR(64),
    color VARCHAR(64)

    CONSTRAINT FK_pID2 FOREIGN KEY (pID) REFERENCES products,
    CONSTRAINT p2_size_check CHECK (size IN ('small', 'medium', 'large'))
);


CREATE TABLE product3 (
    pID VARCHAR(64) PRIMARY KEY,
    size VARCHAR(64),
    weight REAL

    CONSTRAINT FK_pID3 FOREIGN KEY (pID) REFERENCES products,
    CONSTRAINT p3_size_check CHECK (size IN ('small', 'medium', 'large'))
);

CREATE TABLE customer (
    cname VARCHAR(64),
    pID VARCHAR(64),
    address VARCHAR(64)

    PRIMARY KEY (cname, pID)
    CONSTRAINT FK_cPID FOREIGN KEY (pID) REFERENCES products

);

CREATE TABLE complaints (
    cID VARCHAR(64) PRIMARY KEY,
    date DATE,
    description VARCHAR(64),
    treatment_expected VARCHAR(64),
    cname VARCHAR(64) NOT NULL,
    pID VARCHAR(64) NOT NULL

    CONSTRAINT FK_customer FOREIGN KEY (cname, PID) REFERENCES customer
);

CREATE TABLE repair (
    pID VARCHAR(64),
    tech_staff_name VARCHAR(64),
    cID VARCHAR(64),
    qc_name VARCHAR(64),
    date DATE

    PRIMARY KEY (pID, date)
    CONSTRAINT FK_rpID FOREIGN KEY (pID) REFERENCES products,
    CONSTRAINT FK_tsrname FOREIGN KEY (tech_staff_name) REFERENCES technical_staff,
    CONSTRAINT FK_qcrname FOREIGN KEY (qc_name) REFERENCES quality_controller,
    CONSTRAINT FK_cIDr FOREIGN KEY (cID) REFERENCES complaints
);

CREATE TABLE accident (
    number INT PRIMARY KEY,
    date DATE,
    lost_days REAL

);

CREATE TABLE repair_accidents (
    number INT,
    name VARCHAR(64),
    pID VARCHAR (64)

    PRIMARY KEY (number, name, pID)
    CONSTRAINT FK_ranumber FOREIGN KEY (number) REFERENCES accident,
    CONSTRAINT FK_raname FOREIGN KEY (name) REFERENCES technical_staff,
    CONSTRAINT FK_rapID FOREIGN KEY (pID) REFERENCES products
);

CREATE TABLE production_accidents (
    number INT,
    name VARCHAR(64),
    pID VARCHAR (64)

    PRIMARY KEY (number, name, pID)
    CONSTRAINT FK_panumber FOREIGN KEY (number) REFERENCES accident,
    CONSTRAINT FK_paname FOREIGN KEY (name) REFERENCES worker,
    CONSTRAINT FK_papID FOREIGN KEY (pID) REFERENCES products
);


CREATE TABLE account (
    account_no VARCHAR(64) PRIMARY KEY,
    establishment_date DATE,
    cost REAL,
    pID VARCHAR(64)

    CONSTRAINT FK_apID FOREIGN KEY (pID) REFERENCES products
);

CREATE TABLE product1_account (
    account_no VARCHAR(64) PRIMARY KEY,
    pID VARCHAR(64)

    CONSTRAINT FK_p1acc FOREIGN KEY (account_no) REFERENCES account,
    CONSTRAINT FK_p1apID FOREIGN KEY (pID) REFERENCES product1
);

CREATE TABLE product2_account (
    account_no VARCHAR(64) PRIMARY KEY,
    pID VARCHAR(64)

    CONSTRAINT FK_p2acc FOREIGN KEY (account_no) REFERENCES account,
    CONSTRAINT FK_p2apID FOREIGN KEY (pID) REFERENCES product2
);

CREATE TABLE product3_account (
    account_no VARCHAR(64) PRIMARY KEY,
    pID VARCHAR(64)

    CONSTRAINT FK_p3acc FOREIGN KEY (account_no) REFERENCES account,
    CONSTRAINT FK_p3apID FOREIGN KEY (pID) REFERENCES product3
);



--CREATE INDEXES
CREATE INDEX salary_index ON employee(salary);
CREATE INDEX degree_index ON technical_staff_degree(degree);
CREATE INDEX name_index ON quality_controller(name);
CREATE INDEX producedBy_index ON products(produced_by);
CREATE INDEX pID1_index ON product1(pID);
CREATE INDEX pID2_index ON product2(pID);
CREATE INDEX repairPID_index ON repair(pID);
CREATE INDEX date_index ON accident(date);
CREATE INDEX raNumber_index ON repair_accidents(number);
CREATE INDEX paNumber_index ON production_accidents(number);
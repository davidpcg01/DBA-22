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





--QUERIES DEFINED IN QUESTION
DROP PROCEDURE IF EXISTS insert_new_employee;
DROP PROCEDURE IF EXISTS insert_new_product;
DROP PROCEDURE IF EXISTS insert_new_customer;
DROP PROCEDURE IF EXISTS create_new_account;
DROP PROCEDURE IF EXISTS create_new_complaint;
DROP PROCEDURE IF EXISTS enter_new_accident;
DROP PROCEDURE IF EXISTS retrieve_q7;
DROP PROCEDURE IF EXISTS retrieve_q8;
DROP PROCEDURE IF EXISTS retrieve_q9;
DROP PROCEDURE IF EXISTS retrieve_q10;
DROP PROCEDURE IF EXISTS retrieve_q11;
DROP PROCEDURE IF EXISTS retrieve_q12;
DROP PROCEDURE IF EXISTS retrieve_q13;
DROP PROCEDURE IF EXISTS retrieve_q14;
DROP PROCEDURE IF EXISTS retrieve_q15;




--1 enter a new employee
GO
CREATE PROCEDURE insert_new_employee --create a procedure for inserting a new employee
    -- specify the parameters needed by the procedure
    @name VARCHAR(64), --the new employee name
    @address VARCHAR(64), --the new employee address
    @salary REAL, --the new employee salary
    @emptype VARCHAR(64), -- the employee type
    @addl_info VARCHAR(64), -- additional information for the employee subgroups
    @addl_info2 VARCHAR(64) -- degree information if the employee is technical staff
AS
BEGIN
    --write insert sql statement for procedure considering the salary calcuations using case statements
    IF @emptype NOT IN ('technical_staff', 'quality_controller', 'worker') -- check to see that user entered the right type of employee for insertion into employee subgroup table
    BEGIN
        PRINT 'ERROR: Incorrect Entry of employee type, please enter "technical_staff", "quality_controller" or "worker"'
        RETURN;
    END


    -- peform insertions
    INSERT INTO employee
        (name, address, salary)
    VALUES
        (@name, @address, @salary);


    if @emptype = 'technical_staff'
    BEGIN
        INSERT INTO technical_staff
            (name, technical_position)
        VALUES
            (@name, @addl_info);

        INSERT INTO technical_staff_degree
            (name, degree)
        VALUES
            (@name, @addl_info2);
    END
    ELSE IF @emptype = 'quality_controller'
    BEGIN
        INSERT INTO quality_controller 
            (name, product_type)
        VALUES
            (@name, @addl_info);
    END
    ELSE 
    BEGIN
        INSERT INTO worker 
            (name, max_products_per_day)
        VALUES
            (@name, @addl_info);
    END
END

--2 insert new product
GO
CREATE PROCEDURE insert_new_product --create a procedure for inserting a new product
    -- specify the parameters needed by the procedure
    @id VARCHAR(64), --the new product id
    @date DATE, -- date the product was made
    @time VARCHAR(64), -- how long it took to create the product
    @produced_by VARCHAR(64), -- name of worker who made the product
    @tested_by VARCHAR(64), -- name of quality controller who tested the product
    @repaired_by VARCHAR(64), -- name of technical staff who repaired the product, if any
    @producttype VARCHAR(64), -- type of product
    @size VARCHAR(64), -- size of product
    @addl_info VARCHAR(64) --major software for product 1, color for product 2, weight for product 3
AS
BEGIN
    --write insert sql statement for procedure considering the salary calcuations using case statements
    IF @producttype NOT IN ('Product1', 'Product2', 'Product3') -- check that user entered correct product type for insertion into subgroup tables
    BEGIN
        PRINT 'ERROR: The product type is incorrectly specified, please enter "Product1", "Product2" or "Product3"'
        RETURN;
    END

    IF @producttype != (SELECT product_type from quality_controller where name = @tested_by) -- check that the product type can be tested by the entered quality controller name
    BEGIN
        PRINT 'ERROR: This product cannot be tested by the quality controller entered'
        RETURN;
    END

    IF @producttype = 'Product1' AND @repaired_by NOT IN (SELECT name from technical_staff_degree WHERE degree in ('MSC', 'PHD')) --check that the product can be repaired by the specified technical staff based on its type
    BEGIN
        PRINT 'ERROR: The person said to have repaired the product does not have the required qualifications to do so'
        RETURN;
    END

    -- perform the inserts once all the input data has been confirmed
    IF @repaired_by = ''
    BEGIN
        SET @repaired_by = NULL
    END

    INSERT INTO products
        (pID, production_date, creation_time, produced_by, tested_by, repaired_by)
    VALUES
        (@id, @date, @time, @produced_by, @tested_by, @repaired_by);


    IF @producttype = 'Product1'
    BEGIN
        INSERT INTO product1
            (pID, size, major_software)
        VALUES
            (@id, @size, @addl_info);
    END
    ELSE IF @producttype = 'Product2'
    BEGIN
        INSERT INTO product2
            (pID, size, color)
        VALUES
            (@id, @size, @addl_info);
    END
    ELSE 
    BEGIN
        INSERT INTO product3
            (pID, size, weight)
        VALUES
            (@id, @size, @addl_info);
    END
    -- assume all repairs when entering new product was ordered by quality controller and insert in repair table
    --we assume that the product was repaired 1 day after it was produced and tested by quality controller, 
    --this is reflected in the insert statement into the repair table
    IF @repaired_by IS NOT NULL
    BEGIN
        INSERT INTO repair
            (pID, tech_staff_name, qc_name, date)
        VALUES
            (@id, @repaired_by, @tested_by, (SELECT CONVERT(VARCHAR(64), DATEADD(DAY, 1, @date), 101)))
    END
END


--3 Enter a customer associated with some product
GO
CREATE PROCEDURE insert_new_customer --create a procedure for inserting a new product
    -- specify the parameters needed by the procedure
    @cname VARCHAR(64), --customer name
    @pID VARCHAR(64), -- product purchased
    @address VARCHAR(64) --customre address
AS
BEGIN
    --write insert sql statement for procedure considering the salary calcuations using case statements

    INSERT INTO customer
        (cname, pID, address)
    VALUES
        (@cname, @pID, @address);
END

--4 create a new account associated with a product
GO
CREATE PROCEDURE create_new_account --create a procedure for inserting a new product
    -- specify the parameters needed by the procedure
    @account_no VARCHAR(64),
    @date DATE, -- date account was established
    @cost REAL, -- cost of product
    @pID VARCHAR(64) -- product ID
AS
BEGIN
    --write insert sql statement for procedure considering the salary calcuations using case statements
    INSERT INTO account
        (account_no, establishment_date, cost, piD)
    VALUES
        (@account_no, @date, @cost, @pID);

    IF (SELECT pID FROM product1 WHERE pID = @pID) = @pID
    BEGIN
        INSERT INTO product1_account
            (account_no, pID)
        VALUES
            (@account_no, @pID)
    END
    ELSE
    BEGIN
        IF (SELECT pID FROM product2 WHERE pID = @pID) = @pID
        BEGIN
            INSERT INTO product2_account
                (account_no, pID)
            VALUES
                (@account_no, @pID)
        END
        ELSE
        BEGIN
            INSERT INTO product3_account
                (account_no, pID)
            VALUES
                (@account_no, @pID)
        END
    END
END

--5 Enter a complaint associated with a customer and product
GO
CREATE PROCEDURE create_new_complaint --create a procedure for inserting a new product
    -- specify the parameters needed by the procedure
    @cID VARCHAR(64), --complaint ID
    @date DATE, -- Date the complaint was made
    @desc VARCHAR(64), -- description of what is wrong with product
    @treatment_expected VARCHAR(64), --refund or replace the product?
    @cname VARCHAR(64), --customer name 
    @pID VARCHAR(64) -- product being complained about
AS
BEGIN
    --perfom inserts
    INSERT INTO complaints
        (cID, date, description, treatment_expected, cname, pID)
    VALUES
        (@cID, @date, @desc, @treatment_expected, @cname, @pID);

    -- regardless of if a customer wants a refund or a replacement product, the product has to been sent back for repairs
    -- hence we need to know who will be repairing this product

    --This section randomly assigns a techical staff to handle the repair based on the product type
    DECLARE @tech_staff_name VARCHAR(64)

    IF (SELECT pID from product1 where pID = @pID) = @pID
    BEGIN
        SET @tech_staff_name = (SELECT top 1 name from technical_staff_degree WHERE degree IN ('MSC', 'PHD') ORDER BY NEWID())
    END
    ELSE
    BEGIN
        SET @tech_staff_name = (SELECT top 1 name from technical_staff order by NEWID())
    END
    --insert into repair based on complaint
    --we the repair is done 4 days after complaint is made (3 days to ship the product back and 1 day to repair).
    --note that the primary assumption here is that every product that is complained about must be returned, the customer will either
    --get a new one or their money back. and for each product returned it is repaired. We randomly assign compained product to
    --a technical staff based on the product type, i.e product 1 will only be repaired by MSC and PHD holders, product 2 & 3 by anyone else
    INSERT INTO repair
            (pID, tech_staff_name, cID, date)
        VALUES
            (@pID, @tech_staff_name, @cID, (SELECT CONVERT(VARCHAR(64), DATEADD(DAY, 4, @date), 101))); --assume it takes 3 days to return product and 1 day to repair
        
    --update products table with the tech staff who completed complaints based repair
    UPDATE products
        SET repaired_by = @tech_staff_name
        WHERE pID = @pID;
END

--6 Enter an accident associated with an employee and product
GO
CREATE PROCEDURE enter_new_accident --create a procedure for inserting a new product
    -- specify the parameters needed by the procedure
    @number INT, --unique accident number
    @date DATE, --date accident occured
    @lost_days REAL, -- no of days lost due to accident
    @accidenttype VARCHAR(64), -- what type of accident?
    @name VARCHAR(64), -- name of employee involved in accident
    @pID VARCHAR(64) -- product being worked on when accident occured
AS
BEGIN
    IF @accidenttype NOT IN ('repair', 'production') -- check that the accident type is correctly entered
    BEGIN
        PRINT 'ERROR: Incorrect entry of accident type, please enter "repair" or "production"'
        RETURN;
    END

    IF @accidenttype = 'repair' AND (@name NOT IN (SELECT tech_staff_name FROM repair) OR @pID NOT IN (SELECT pID FROM repair)) -- check that the technical staff and product being repaired exists in the repair table
    BEGIN
        PRINT 'ERROR: A repair by the technical staff for the specified product does not exist in database'
        RETURN;
    END
    
    --perform inserts
    IF @accidenttype = 'repair' 
    BEGIN
        INSERT INTO accident
            (number, date, lost_days)
        VALUES
            (@number, @date, @lost_days);

        INSERT INTO repair_accidents
            (number, name, pID)
        VALUES
            (@number, @name, @pID)
    END
    ELSE IF @accidenttype = 'production' 
    BEGIN
        INSERT INTO accident
            (number, date, lost_days)
        VALUES
            (@number, @date, @lost_days);

        INSERT INTO production_accidents
            (number, name, pID)
        VALUES
            (@number, @name, @pID)
    END
END


--7 Retrieve the date produced and time spent to produce a particular product
GO
CREATE PROCEDURE retrieve_q7 
    -- specify the parameters needed by the procedure
    @pID VARCHAR(64) -- product ID you want to get production data and creation time for
AS
BEGIN
    SELECT production_date, creation_time
    FROM products 
    WHERE pID = @pID;
END

--8 Retrieve all products made by a particular worker
GO
CREATE PROCEDURE retrieve_q8 
    -- specify the parameters needed by the procedure
    @workername VARCHAR(64) -- worker name that you want to get all products made by them
AS
BEGIN
    SELECT pID
    FROM products 
    WHERE produced_by = @workername;
END

--9 Retrieve the total number of errors a particular quality controller made. This is the total number of
-- products certified by this controller and got some complaints
GO
CREATE PROCEDURE retrieve_q9 
    -- specify the parameters needed by the procedure
    @qcname VARCHAR(64) --quality controller name
AS
BEGIN
    SELECT COUNT(pID) AS total_errors
    FROM products 
    WHERE tested_by = @qcname
    AND pID IN ((SELECT pID FROM repair where qc_name IS NULL) EXCEPT (SELECT pID FROM repair WHERE qc_name IS NOT NULL))
END


--10 Retrieve the total costs of the products in product3 category which were repaired at the request of a particular quality controller
GO
CREATE PROCEDURE retrieve_q10 
    -- specify the parameters needed by the procedure
    @qcname VARCHAR(64) -- quality controller name
AS
BEGIN
    SELECT SUM(A.cost) as total_cost
    FROM account A, product3_account P, repair R
    WHERE A.account_no = P.account_no
    AND P.pID = R.pID
    AND R.qc_name = @qcname;
END

--11 Retrieve all customers (in name order) who purchased all products of a particular color
GO
CREATE PROCEDURE retrieve_q11 
    -- specify the parameters needed by the procedure
    @color VARCHAR(64) --product color
AS
BEGIN
    SELECT C.cname
    FROM customer C, product2 P
    WHERE C.pID = P.pID
    AND P.color = @color
    ORDER BY C.cname;
END


--12 Retrieve all employees whose salary is above a particular salary
GO
CREATE PROCEDURE retrieve_q12 
    -- specify the parameters needed by the procedure
    @salary REAL -- specified salary
AS
BEGIN
    SELECT name 
    FROM employee
    WHERE salary > @salary;
END


--13 Retrieve the total number of work days lost due to accidents in repairing the products which got complaints
GO
CREATE PROCEDURE retrieve_q13 
AS
BEGIN
    SELECT SUM(A.lost_days) AS total_lost_days
    FROM accident A, repair_accidents RA, repair R
    WHERE A.number = RA.number
    AND RA.pID = R.pID
    AND R.cID IS NOT NULL;
END


--14 Retrieve the average cost of all products made in a particular year
GO
CREATE PROCEDURE retrieve_q14 
    -- specify the parameters needed by the procedure
    @year VARCHAR(64) -- specified year
AS
BEGIN
    SELECT ROUND(AVG(A.cost),3) AS average_cost
    FROM account A, products P
    WHERE A.pID = P.pID
    AND YEAR(P.production_date) = @year;
END

--15 Delete all accidents whose dates are in some range
GO
CREATE PROCEDURE retrieve_q15 
    -- specify the parameters needed by the procedure
    @startdate VARCHAR(64), -- specified start date
    @enddate VARCHAR(64) -- specified end date
AS
BEGIN
    DELETE FROM repair_accidents 
    WHERE number IN (
        SELECT number FROM accident
        WHERE date between @startdate and @enddate);

    DELETE FROM production_accidents 
    WHERE number IN (
        SELECT number FROM accident
        WHERE date between @startdate and @enddate);

    DELETE FROM accident
    WHERE date between @startdate and @enddate;
END





--Testing code
--NOT TO BE GRADED

--query 1 x10
GO
EXEC insert_new_employee @name = 'Macy', @address = 'TX', @salary = 45000, @emptype = 'technical_staff', @addl_info = 'Senior', @addl_info2 = 'MSC';
EXEC insert_new_employee @name = 'Mazekin', @address = 'OK', @salary = 45000, @emptype = 'technical_staff', @addl_info = 'Senior', @addl_info2 = 'MSC';
EXEC insert_new_employee @name = 'Nancy', @address = 'OK', @salary = 45000, @emptype = 'technical_staff', @addl_info = 'Junior', @addl_info2 = 'BSC';
EXEC insert_new_employee @name = 'Jerry', @address = 'KS', @salary = 45000, @emptype = 'technical_staff', @addl_info = 'Manager', @addl_info2 = 'PHD';
EXEC insert_new_employee @name = 'John', @address = 'NY', @salary = 33000, @emptype = 'quality_controller', @addl_info = 'product1', @addl_info2 = '';
EXEC insert_new_employee @name = 'James', @address = 'NY', @salary = 33000, @emptype = 'quality_controller', @addl_info = 'product2', @addl_info2 = '';
EXEC insert_new_employee @name = 'Carey', @address = 'KS', @salary = 28000, @emptype = 'quality_controller', @addl_info = 'product3', @addl_info2 = '';
EXEC insert_new_employee @name = 'Ada', @address = 'OK', @salary = 25000, @emptype = 'worker', @addl_info = '10', @addl_info2 = '';
EXEC insert_new_employee @name = 'Adam', @address = 'OK', @salary = 30000, @emptype = 'worker', @addl_info = '15', @addl_info2 = '';
EXEC insert_new_employee @name = 'Jessie', @address = 'NY', @salary = 35000, @emptype = 'worker', @addl_info = '18', @addl_info2 = '';



--- query 2 x10
EXEC insert_new_product @id = '001', @date = '10/26/2022', @time = '7', @produced_by = 'Ada', @tested_by = 'John', @repaired_by = 'Macy', 
                                @producttype = 'Product1', @size = 'small', @addl_info = 'Apple';
EXEC insert_new_product @id = '002', @date = '10/26/2022', @time = '10', @produced_by = 'Adam', @tested_by = 'John', @repaired_by = Null, 
                                @producttype = 'Product1', @size = 'medium', @addl_info = 'Google';
EXEC insert_new_product @id = '003', @date = '10/26/2022', @time = '15', @produced_by = 'Adam', @tested_by = 'John', @repaired_by = 'Jerry', 
                                @producttype = 'Product1', @size = 'large', @addl_info = 'Google';
EXEC insert_new_product @id = '004', @date = '10/26/2023', @time = '7', @produced_by = 'Ada', @tested_by = 'John', @repaired_by = Null, 
                                @producttype = 'Product1', @size = 'small', @addl_info = 'Google';                                
EXEC insert_new_product @id = '005', @date = '10/26/2022', @time = '5', @produced_by = 'Adam', @tested_by = 'James', @repaired_by = 'Nancy', 
                                @producttype = 'Product2', @size = 'small', @addl_info = 'green';
EXEC insert_new_product @id = '006', @date = '10/26/2022', @time = '7', @produced_by = 'Jessie', @tested_by = 'James', @repaired_by = 'Mazekin', 
                                @producttype = 'Product2', @size = 'medium', @addl_info = 'yellow';
EXEC insert_new_product @id = '007', @date = '10/26/2023', @time = '10', @produced_by = 'Adam', @tested_by = 'James', @repaired_by = Null, 
                                @producttype = 'Product2', @size = 'large', @addl_info = 'green';
EXEC insert_new_product @id = '008', @date = '10/26/2022', @time = '3', @produced_by = 'Jessie', @tested_by = 'Carey', @repaired_by = Null, 
                                @producttype = 'Product3', @size = 'small', @addl_info = '20.5';
EXEC insert_new_product @id = '009', @date = '10/26/2022', @time = '5', @produced_by = 'Jessie', @tested_by = 'Carey', @repaired_by = 'Macy', 
                                @producttype = 'Product3', @size = 'medium', @addl_info = '30.5';
EXEC insert_new_product @id = '010', @date = '10/26/2023', @time = '7', @produced_by = 'Adam', @tested_by = 'Carey', @repaired_by = Null, 
                                @producttype = 'Product3', @size = 'large', @addl_info = '40.5';



-- query 3 x10
EXEC insert_new_customer @cname = 'David Nnamdi', @pID = '001', @address = 'TX';
EXEC insert_new_customer @cname = 'David Nnamdi', @pID = '004', @address = 'TX';
EXEC insert_new_customer @cname = 'David Nnamdi', @pID = '009', @address = 'TX';
EXEC insert_new_customer @cname = 'Melissa Nnamdi', @pID = '002', @address = 'TX';
EXEC insert_new_customer @cname = 'Melissa Nnamdi', @pID = '005', @address = 'TX';
EXEC insert_new_customer @cname = 'Kanayo Nnamdi', @pID = '003', @address = 'TX';
EXEC insert_new_customer @cname = 'Kanayo Nnamdi', @pID = '010', @address = 'TX';
EXEC insert_new_customer @cname = 'Chinelo Nnamdi', @pID = '006', @address = 'TX';
EXEC insert_new_customer @cname = 'Samuel Nnamdi', @pID = '008', @address = 'TX';
EXEC insert_new_customer @cname = 'Nnamdi Nnamdi', @pID = '007', @address = 'TX';

-- query 4 x10
EXEC create_new_account @account_no = '001', @date = '10/26/2022', @cost = 50.5, @pID = '001';
EXEC create_new_account @account_no = '002', @date = '10/26/2022', @cost = 66.5, @pID = '002';
EXEC create_new_account @account_no = '003', @date = '10/26/2022', @cost = 70.5, @pID = '003';
EXEC create_new_account @account_no = '004', @date = '10/26/2023', @cost = 50.5, @pID = '004';
EXEC create_new_account @account_no = '005', @date = '10/26/2022', @cost = 66.5, @pID = '005';
EXEC create_new_account @account_no = '006', @date = '10/26/2022', @cost = 70.5, @pID = '006';
EXEC create_new_account @account_no = '007', @date = '10/26/2023', @cost = 50.5, @pID = '007';
EXEC create_new_account @account_no = '008', @date = '10/26/2022', @cost = 66.5, @pID = '008';
EXEC create_new_account @account_no = '009', @date = '10/26/2022', @cost = 70.5, @pID = '009';
EXEC create_new_account @account_no = '010', @date = '10/26/2023', @cost = 70.5, @pID = '010';

--query 5 x3
EXEC create_new_complaint @cID = '111', @date = '11/01/2022', @desc = 'not working', @treatment_expected = 'replace', @cname = 'David Nnamdi', @pID = '004';
EXEC create_new_complaint @cID = '112', @date = '11/02/2022', @desc = 'broken', @treatment_expected = 'replace', @cname = 'Melissa Nnamdi', @pID = '002';
EXEC create_new_complaint @cID = '113', @date = '11/03/2022', @desc = 'not working', @treatment_expected = 'refund', @cname = 'Chinelo Nnamdi', @pID = '006';

-- query 6 x3
EXEC enter_new_accident @number = 1, @date = '10/26/2022', @lost_days = 1, @accidenttype = 'repair', @name = 'Macy', @pID = '001';
EXEC enter_new_accident @number = 2, @date = '10/26/2022', @lost_days = 2, @accidenttype = 'production', @name = 'Adam', @pID = '007';
EXEC enter_new_accident @number = 3, @date = '10/26/2022', @lost_days = 1, @accidenttype = 'repair', @name = 'Mazekin', @pID = '004';
EXEC enter_new_accident @number = 4, @date = '10/26/2022', @lost_days = 2, @accidenttype = 'repair', @name = 'Jerry', @pID = '003';

-- query 7 x3
EXEC retrieve_q7 @pID = '001';
EXEC retrieve_q7 @pID = '002';
EXEC retrieve_q7 @pID = '003';

-- query 8 x3
EXEC retrieve_q8 @workername = 'Ada';
EXEC retrieve_q8 @workername = 'Adam';
EXEC retrieve_q8 @workername = 'Jessie';

-- query 9 x3
EXEC retrieve_q9 @qcname = 'John';
EXEC retrieve_q9 @qcname = 'James';
EXEC retrieve_q9 @qcname = 'Carey';

-- query 10 x3
EXEC retrieve_q10 @qcname = 'John';
EXEC retrieve_q10 @qcname = 'James';
EXEC retrieve_q10 @qcname = 'Carey';

-- query 11 x3
EXEC retrieve_q11 @color = 'green';
EXEC retrieve_q11 @color = 'yellow';
EXEC retrieve_q11 @color = 'green';

-- query 12 x1
EXEC retrieve_q12 @salary = 30000;

-- query 13 x1
EXEC retrieve_q13;

-- query 14 x1
EXEC retrieve_q14 @year = 2023;

-- query 15 x1
EXEC retrieve_q15 @startdate = '9/1/2022', @enddate = '11/1/2022';




Select * from employee;
select * from technical_staff;
select * from technical_staff_degree;
select * from quality_controller;
select * from worker;
select * from products;
select * from product1;
select * from product2;
select * from product3;
select * from account;
select * from product1_account;
select * from product2_account;
select * from product3_account;
select * from customer;
select * from repair;
select * from complaints;
select * from accident;
select * from repair_accidents;
select * from production_accidents;


/*
delete from product1_account
delete from product2_account;
delete from product3_account
DELETE FROM account;
delete from product1;
delete from product2;
delete from product3;
delete from products;
delete from technical_staff_degree;
delete from technical_staff;
delete from worker;
delete from quality_controller;
delete from employee;*/


---creating hash index
ALTER TABLE products
ADD INDEX ix_hash_produced_by NONCLUSTERED
HASH (produced_by) WITH (BUCKET_COUNT = 64);

insert into product1 
    (pID, size, major_software)
VALUES
    (011, 'tiny', 'Apple');

EXEC insert_new_product @id = '012', @date = '10/26/2022', @time = '7', @produced_by = 'Ada', @tested_by = 'John', @repaired_by = 'Macy', 
                                @producttype = 'Product1', @size = 'mixro', @addl_info = 'Apple';
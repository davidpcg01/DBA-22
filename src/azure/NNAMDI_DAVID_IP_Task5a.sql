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
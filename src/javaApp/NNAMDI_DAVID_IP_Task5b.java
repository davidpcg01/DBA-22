import java.sql.Connection;
//import java.sql.Statement;
import java.util.ArrayList;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLWarning;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.FileWriter;

public class project {

    // Database credentials
    final static String HOSTNAME = "<enter-az-host>";
    final static String DBNAME = "<enter-azure-db-name>";
    final static String USERNAME = "<enter-username>";
    final static String PASSWORD = "<enter-password>";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);


    // User input prompt//
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            "1) Enter a new employee; \n" + 
            "2) Enter a new product associated with the person who made the product, repaired the product if it is repaired, or checked the product; \n" +
            "3) Enter a customer associated with some products; \n" + 
            "4) Create a new account associated with a product; \n" + 
            "5) Enter a complaint associated with a customer and product; \n" + 
            "6) Enter an accident associated with an appropriate employee and product; \n" + 
            "7) Retrieve the date produced and time spent to produce a particular product; \n" + 
            "8) Retrieve all products made by a particular worker; \n" + 
            "9) Retrieve the total number of errors a particular quality controller made. This is the total number of products certified by this controller and got some complaints; \n" + 
            "10) Retrieve the total costs of the products in the product3 category which were repaired at the request of a particular quality controller; \n" + 
            "11) Retrieve all customers (in name order) who purchased all products of a particular color; \n" + 
            "12) Retrieve all employees whose salary is above a particular salary; \n" + 
            "13) Retrieve the total number of work days lost due to accidents in repairing the products which got complaints; \n" + 
            "14) Retrieve the average cost of all products made in a particular year; \n" + 
            "15) Delete all accidents whose dates are in some range; \n" + 
            "16) Import: enter new employees from a data file until the file is empty; \n" + 
            "17) Export: Retrieve all customers (in name order) who purchased all products of a particular color and output them to a data file instead of screen; \n" + 
            "18) Quit";

    public static void main(String[] args) throws SQLException {

        System.out.println("WELCOME TO THE DATABASE SYSTEM OF MyProducts, Inc.");

        final Scanner sc = new Scanner(System.in); // Scanner is used to collect the user input
        String option = ""; // Initialize user option selection as nothing
        while (!option.equals("18")) { // As user for options until option 4 is selected
            System.out.println(PROMPT); // Print the available options
            option = sc.nextLine(); // Read in the user option selection

            switch (option) { // Switch between different options
                case "1": // Insert a new employee
                	
                    // Collect the new employee data from the user
                    System.out.println("Please enter employee type: enter 'technical_staff', 'quality_controller' or 'worker'");
                    final String emptype = sc.nextLine(); // Read in the employee type

                    System.out.println("Please enter employee name:");
                    final String name = sc.nextLine(); // Read in user input of employee name (white-spaces allowed).
                    
                    System.out.println("Please enter employee address:");
                    final String address = sc.nextLine(); // Read in user input of employee address (white-spaces allowed).
                    
                    System.out.println("Please enter employee salary:");
                    final float salary = sc.nextFloat(); // Read in user input of employee salary
                    sc.nextLine();
                    
                    System.out.println("Please enter additional information for employee:");
                    System.out.println("For technical staff, enter the technical position");
                    System.out.println("For quality controller, enter product type to be checked: ('product1', 'product2', 'product3')");
                    System.out.println("For worker, enter the maximum number of products worker can produce per day");
                    final String addl_info = sc.nextLine(); // Read in user input of employee additional info based on type
                    
                    System.out.println("Please enter employee degree if the employee is a technical staff otherwise press Enter Key:");
                    System.out.println("Enter 'BSC', 'MSC' or 'PHD' for technical staff");
                    final String addl_info2 = sc.nextLine(); // Read in user input of employee degree

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC insert_new_employee @name = ?, @address = ?, @salary = ?, "
                            		                                                          + "@emptype = ?, @addl_info = ?, @addl_info2 = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, name);
                            statement.setString(2, address);
                            statement.setFloat(3, salary);
                            statement.setString(4, emptype);
                            statement.setString(5, addl_info);
                            statement.setString(6, addl_info2);
                            

                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            final SQLWarning warning = statement.getWarnings();
                            if (warning != null)
                            		System.out.println(warning.getMessage());
                            else
                            	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }
                  
                    
                    break;
                case "2": //Insert a new product
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter product type: enter 'Product1', 'Product2' or 'Product3'");
                    final String producttype = sc.nextLine(); // Read in the product type
                    
                    System.out.println("Please enter the product id:");
                    final String id = sc.nextLine(); // Read in user input of product ID 
                    
                    System.out.println("Please enter date the product was produced in mm/dd/yyyy:");
                    final String date = sc.nextLine(); // Read in user input of date product was made
                    
                    System.out.println("Please enter time spent to make the product in hours:");
                    final String time = sc.nextLine(); // Read in user input of how long it took to make product

                    System.out.println("Please enter name of worker who produced the product:");
                    final String produced_by = sc.nextLine(); // Read in user input of worker name who made product (white-spaces allowed).
                    
                    System.out.println("Please enter name of quality controller who tested the product:");
                    final String tested_by = sc.nextLine(); // Read in user input of quality controller name who tested product (white-spaces allowed).
                    
                    System.out.println("Please enter name of technical staff who repaired the product:");
                    System.out.println("If product was not repaired, press Enter Key to skip");
                    final String repaired_by = sc.nextLine(); // Read in user input of technical staff name who repaired product if any (white-spaces allowed).
                    
                    System.out.println("Please enter the size of the product, ('small', 'medium' or 'large'):");
                    final String size = sc.nextLine(); // Read in user input of product size
                    
                    System.out.println("Please enter additional information for product:");
                    System.out.println("For Product 1, enter the major software used");
                    System.out.println("For Product 2, enter the color");
                    System.out.println("For Product 3, enter the weight");
                    final String addl_info_q2 = sc.nextLine(); // Read in user input of additional information for the specific product type
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC insert_new_product @id = ?, @date = ?, @time = ?, @produced_by = ?, "
                            		                                                          + "@tested_by = ?, @repaired_by = ?, @producttype = ?, @size = ?, @addl_info = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, id);
                            statement.setString(2, date);
                            statement.setString(3, time);
                            statement.setString(4, produced_by);
                            statement.setString(5, tested_by);
                            statement.setString(6, repaired_by);
                            statement.setString(7, producttype);
                            statement.setString(8, size);
                            statement.setString(9, addl_info_q2);

                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            final SQLWarning warning = statement.getWarnings();
                            if (warning != null)
                            		System.out.println(warning.getMessage());
                            else
                            	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "3": //Insert a new customer associated with some products
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter the customer name:'");
                    final String cname = sc.nextLine(); // Read in the customer name (white-spaces allowed).
                    
                    
                    System.out.println("Please enter the customer address:");
                    final String caddress = sc.nextLine(); // Read in user input of customer address (white-spaces allowed).
                    
                    System.out.println("Please enter all products purchased by customer, separate each entry with a space:");
                    System.out.println("When done with entering all products, press Enter and 'end':");
                    ArrayList<String> pidlist = new ArrayList<String>(); // create array list to store all the user entry of products purchased by customer
                    boolean choice = false;
                    
                    //populate the array list with user input and stop when user enters end keyword
                    while(choice == false){
                        String line = sc.nextLine();
                        if(line.equalsIgnoreCase("end")){
                            break;
                        }
                        else{
                            String[] splitArr = line.split(" "); // split the user entry into individual products and store in a string array
                            for (String a : splitArr) {
                            	pidlist.add(a);
                            }
                        } 
                    }
                    
                    System.out.println("Connecting to the database...");
                    
                    int val = 0;
                    
                    //perform insertion into customer table until the products entered are exhausted
                    while (pidlist.size() > val) {
                    	String temppid;
                    	temppid = pidlist.get(val);
                    

	                    
	                    // Get a database connection and prepare a query statement
	                    try (final Connection connection = DriverManager.getConnection(URL)) {
	                        try (
	                            final PreparedStatement statement = connection.prepareStatement("EXEC insert_new_customer @cname = ?, @pID = ?, "
	                            		                                                          + "@address = ?;")) {
	                            // Populate the query template with the data collected from the user
	                            statement.setString(1, cname);
	                            statement.setString(2, temppid);
	                            statement.setString(3, caddress);
	
	
	                            System.out.println("Dispatching the query...");
	                            // Actually execute the populated query
	                            final int rows_inserted = statement.executeUpdate();
	                            final SQLWarning warning = statement.getWarnings();
	                            if (warning != null)
	                            		System.out.println(warning.getMessage());
	                            else
	                            	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
	                        }
	                    }
	                    catch(SQLException sqe) {
	                    	System.out.println("Error Message = " + sqe.getMessage());
	                    }
                    
                    val++;
                    }

                    break;
                case "4": //create a new account
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter account number:");
                    final String account_no = sc.nextLine(); // Read in user input of the account number
                    
                    System.out.println("Please enter the date the account was established in mm/dd/yyyy:");
                    final String adate = sc.nextLine(); // Read in user input of the date the account was established
                    
                    System.out.println("Please enter the id of the product we want to establish an account for:");
                    final String apid = sc.nextLine(); // Read in user input of product id to establish account for
                    
                    System.out.println("Please enter cost of product:");
                    final float cost = sc.nextFloat(); // Read in user input of cost of product
                    sc.nextLine();

                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC create_new_account @account_no = ?, @date = ?, @cost = ?, "
                            		                                                          + "@pID = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, account_no);
                            statement.setString(2, adate);
                            statement.setFloat(3, cost);
                            statement.setString(4, apid);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            final SQLWarning warning = statement.getWarnings();
                            if (warning != null)
                            		System.out.println(warning.getMessage());
                            else
                            	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "5": //Insert a new complaint
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter product complaint id:");
                    final String cID = sc.nextLine(); // Read in user input of complaint id
                    
                    System.out.println("Please enter date of complaint in mm/dd/yyyy:");
                    final String cdate = sc.nextLine(); // Read in user input of date of complaint
                    
                    System.out.println("Please enter name of customer who has filed a complaint:");
                    final String c_cname = sc.nextLine(); // Read in user input of name of customer filing the complaint
                    
                    System.out.println("Please enter the product id:");
                    final String pid = sc.nextLine(); // Read in user input of the id of the product being complained about
                    
                    System.out.println("Please enter description of what is wrong with product:");
                    final String desc = sc.nextLine(); // Read in user input of what's wrong with product(white-spaces allowed).
                    
                    
                    System.out.println("Please enter treament expected for complaint:");
                    System.out.println("Enter 'refund' if customer wants to return product and be refunded");
                    System.out.println("Enter 'replace' if customer wants the product to be replaced with a working one");
                    final String treatment_expected = sc.nextLine(); // Read in user input of treatment expected
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC create_new_complaint @cID = ?, @date = ?, @desc = ?, @treatment_expected = ?, "
                            		                                                          + "@cname = ?, @pID = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, cID);
                            statement.setString(2, cdate);
                            statement.setString(3, desc);
                            statement.setString(4, treatment_expected);
                            statement.setString(5, c_cname);
                            statement.setString(6, pid);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            final SQLWarning warning = statement.getWarnings();
                            if (warning != null)
                            		System.out.println(warning.getMessage());
                            else
                            	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "6": //Insert a new accident
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter the accident type:");
                    System.out.println("Enter 'repair' if accident occured during product repair");
                    System.out.println("Enter 'production' if accident occured during production of product");
                    final String accidenttype = sc.nextLine(); // Read in user input of accident type
                	
                	System.out.println("Please enter accident number:");
                    final int number = sc.nextInt(); // Read in user input of the unique accident number
                    sc.nextLine();
                    
                    System.out.println("Please enter date of accident in mm/dd/yyyy:");
                    final String acdate = sc.nextLine(); // Read in user input of the date the accident occurred
                    
                    System.out.println("Please enter number of days lost due to accident:");
                    final Float lost_days = sc.nextFloat(); // Read in user input of the number of days lost due to the accident
                    sc.nextLine();
                    
                    System.out.println("Please enter name of employee involved in accident:");
                    final String acname = sc.nextLine(); // Read in user input of employee name involved in accident (white-spaces allowed).
                    
                    
                    System.out.println("Please enter id of product being worked on during the accident:");
                    final String acpid = sc.nextLine(); // Read in user input of product id being worked on during the accident
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC enter_new_accident @number = ?, @date = ?, @lost_days = ?, @accidenttype = ?, "
                            		                                                          + "@name = ?, @pID = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, number);
                            statement.setString(2, acdate);
                            statement.setFloat(3, lost_days);
                            statement.setString(4, accidenttype);
                            statement.setString(5, acname);
                            statement.setString(6, acpid);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            final SQLWarning warning = statement.getWarnings();
                            if (warning != null)
                            		System.out.println(warning.getMessage());
                            else
                            	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "7": //Retrieve the date produced and the time spent to make a product
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter product ID:");
                    final String pID_q7 = sc.nextLine(); // Read in the user input of the product ID
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q7 @pID = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, pID_q7);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 7 query results:");
                            System.out.println("production date | creation time ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s | %s ",
                                       resultSet.getString(1),
                                       resultSet.getString(2)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "8": //Retrieve all products made by a particular worker
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter name of worker:");
                    final String workername = sc.nextLine(); // Read in the user input of the worker name
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q8 @workername = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, workername);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 8 query results:");
                            System.out.println("product id ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "9": //Retrieve erroneously certified products by a quality controller
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter name of quality controller:");
                    final String qcname = sc.nextLine(); // Read in the user input of the quality controller name
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q9 @qcname = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, qcname);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 9 query results:");
                            System.out.println("total errors ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "10": //Retrieve total costs of product3 type products repaired by a quality controller
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter name of quality controller:");
                    final String qcname2 = sc.nextLine(); // Read in the product type
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q10 @qcname = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, qcname2);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 10 query results:");
                            System.out.println("total cost ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "11": //Retrieve all customers (sorted by name) who purchased product of particular color
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter color of products:");
                    final String color = sc.nextLine(); // Read in the product color
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q11 @color = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, color);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 11 query results:");
                            System.out.println("customer name ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "12": //Retrieve all employees with salary above a particular salary
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter target salary:");
                    final Float salary_q12 = sc.nextFloat(); // Read in the particular salary
                    sc.nextLine();
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q12 @salary = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setFloat(1, salary_q12);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 12 query results:");
                            System.out.println("employee name ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "13": //Retrieve total number of lost work days due to accidents in repairing the products which got complaints
                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q13;")) {


                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 13 query results:");
                            System.out.println("total lost days ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "14": //Retrieve the average cost of all products made in a particular year
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter year of interest:");
                    final String year = sc.nextLine(); // Read in the year of interest
                    
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q14 @year = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, year);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();

                            System.out.println("Option 14 query results:");
                            System.out.println("average cost ");
                            	
                            while (resultSet.next()) {
                                   System.out.println(String.format("%s ",
                                       resultSet.getString(1)));
                                }
                            	
                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "15": //Delete all accidents whose dates are in some range
                	
                	// Collect the new faculty data from the user
                	System.out.println("Please enter start date in mm/dd/yyyy:");
                    final String startdate = sc.nextLine(); // Read in the start date of period being considered
                    
                    
                    // Collect the new faculty data from the user
                	System.out.println("Please enter end date in mm/dd/yyyy:");
                    final String enddate = sc.nextLine(); // Read in the end date of period being considered
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q15 @startdate = ?, @enddate = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, startdate);
                            statement.setString(2, enddate);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_affected = statement.executeUpdate();
                            final SQLWarning warning = statement.getWarnings();
                            if (warning != null)
                            		System.out.println(warning.getMessage());
                            else
                            	System.out.println(String.format("Done. %d rows affected.", rows_affected));

                        }
                    }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }

                    break;
                case "16": //Import: enter new employees from file
                	System.out.println("Please enter file name:");
                    final String filename = sc.nextLine(); //Read in file name from user
           
                    // try to read in file and get the specific user input for insertion using query 1
                	try {
                	File myFile = new File(filename+".txt");
                	Scanner myReader = new Scanner(myFile);
                	System.out.println("Reading File...");
                	while (myReader.hasNextLine()) {
                		String data = myReader.nextLine();
                		String[] splitdata = data.split(", ");
                		final String f_emptype = splitdata[0];
                		final String f_name = splitdata[1];
                		final String f_address = splitdata[2];
                		final String f_salary =  splitdata[3];
                		final String f_addl_info = splitdata[4];
                		int spd_size = splitdata.length;
                		final String f_addl_info2;
                		if (spd_size == 6) {
                			f_addl_info2 = splitdata[5];
                		}
                		else {
                			f_addl_info2 = " ";
                		}
                		// after reading in all the required info, run query 1
                		try (final Connection connection = DriverManager.getConnection(URL)) {
                            try (
                                final PreparedStatement statement = connection.prepareStatement("EXEC insert_new_employee @name = ?, @address = ?, @salary = ?, "
                                		                                                          + "@emptype = ?, @addl_info = ?, @addl_info2 = ?;")) {
                                // Populate the query template with the data collected from the user
                                statement.setString(1, f_name);
                                statement.setString(2, f_address);
                                statement.setString(3, f_salary);
                                statement.setString(4, f_emptype);
                                statement.setString(5, f_addl_info);
                                statement.setString(6, f_addl_info2);
                                

                                System.out.println("Dispatching the query...");
                                // Actually execute the populated query
                                final int rows_inserted = statement.executeUpdate();
                                final SQLWarning warning = statement.getWarnings();
                                if (warning != null)
                                		System.out.println(warning.getMessage());
                                else
                                	System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                            	}
                			}
                		catch(SQLException sqe) {
                        	System.out.println("Error Message = " + sqe.getMessage());
                        }

                	 	}
                	myReader.close();
                	} catch (FileNotFoundException e) {
                		System.out.println("ERROR: File Not Found, Please Enter right file name.");
                	}
                	
                	
                    break;
                case "17": //Export: retrieve all customers that purchased particular color products into a file
                	
                	// Collect the data from the user
                	System.out.println("Please enter color of products:");
                    final String f_color = sc.nextLine(); // Read in the color of products
                    
                    System.out.println("Please enter output file name:");
                    final String outfile = sc.nextLine(); // Read in file name to store output file
                    

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement("EXEC retrieve_q11 @color = ?;")) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, f_color);

                            
                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();
                            // write the ouput of teh query into a new text file and save it	
                            try {
                            	FileWriter myWriter = new FileWriter(outfile+".txt");
                            	while (resultSet.next()) {
                            		myWriter.write(resultSet.getString(1));
                            		myWriter.write("\n");

                            	}
                        		myWriter.close(); 
                            	} catch (IOException e) {
                            		System.out.println("An Error Occured, Could not write to File");
                            	}
                           }
                            	
                        }
                    catch(SQLException sqe) {
                    	System.out.println("Error Message = " + sqe.getMessage());
                    }
                

                    break;
                case "18": // Do nothing, the while loop will terminate upon the next iteration
                    System.out.println("Exiting! Goodbye!");
                    break;
                default: // Unrecognized option, re-prompt the user for the correct one
                    System.out.println(String.format(
                        "Unrecognized option: %s\n" + 
                        "Please try again!", 
                        option));
                    break;
            }
        }

        sc.close(); // Close the scanner before exiting the application
    }
}

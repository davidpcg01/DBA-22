package DSA4513_project;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class DataHandler {

    private Connection conn;

    // Azure SQL connection credentials
    private String server = "nnam0000-sql-server.database.windows.net";
    private String database = "cs-dsa-4513-sql-db";
    private String username = "nnam0000";
    private String password = "Onyinye26$$";

    // Resulting connection string
    final private String url =
            String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
                    server, database, username, password);

    // Initialize and save the database connection
    private void getDBConnection() throws SQLException {
        if (conn != null) {
            return;
        }

        this.conn = DriverManager.getConnection(url);
    }
   
   
    
    
    // Inserts an employee using stored procedure for q1 with the given attribute values
    public boolean addEmployee(
            String emptype, String name, String address, float salary, String addl_info, String addl_info2) throws SQLException {

        getDBConnection(); // Prepare the database connection

        // Prepare the SQL statement
        final String sqlQuery =
        		"EXEC insert_new_employee @name = ?, @address = ?, @salary = ?, " + 
        				"@emptype = ?, @addl_info = ?, @addl_info2 = ?;";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);

        // Replace the '?' in the above statement with the given attribute values
        stmt.setString(1, name);
        stmt.setString(2, address);
        stmt.setFloat(3, salary);
        stmt.setString(4, emptype);
        stmt.setString(5, addl_info);
        stmt.setString(6, addl_info2);


        // Execute the query, if only one record is updated, then we indicate success by returning true
        return stmt.executeUpdate() == 1;
    }
    
    // Return all employees with salary great than the given attribute value
    public ResultSet getEmpGreaterSalary(float salary) throws SQLException {

        getDBConnection(); // Prepare the database connection

        // Prepare the SQL statement
        final String sqlQuery = "EXEC retrieve_q12 @salary = ?;";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);

        // Replace the '?' in the above statement with the given attribute values
        stmt.setFloat(1, salary);


        // Execute the query, if only one record is updated, then we indicate success by returning true
        return stmt.executeQuery();
    }
    
}

<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query Result</title>
</head>
    <body>
    <%@page import="DSA4513_project.DataHandler"%>
    <%@page import="java.sql.ResultSet"%>
    <%@page import="java.sql.Array"%>
    <%
    // The handler is the one in charge of establishing the connection.
    DataHandler handler = new DataHandler();

    // Get the attribute values passed from the input form.
    String salary = request.getParameter("salary");


    /*
     * If the user hasn't filled out the salary correctly. This is very simple checking.
     */
    if (salary.equals("")) {
        response.sendRedirect("get_emp_salary_greater_form.jsp");
    } else {
        float salary_ = Float.parseFloat(salary);
        
	 	// Now perform the query with the data from the form.
	    final ResultSet employees = handler.getEmpGreaterSalary(salary_);
	    %>
	    <!-- The table for displaying all the employee records -->
	        <table cellspacing="2" cellpadding="2" border="1">
	            <tr> <!-- The table headers row -->
	              <td align="center">
	                <h4>Employee name</h4>
	              </td>
	            </tr>
	            <%
	               while(employees.next()) { // For each movie_night record returned...
	                   // Extract the attribute values for every row returned
	                   final String name = employees.getString("name");
	
	                   
	                   out.println("<tr>"); // Start printing out the new table row
	                   out.println( // Print each attribute value
	                        "<td align=\"center\">" + name + "</td>");
	                   out.println("</tr>");
	               }
	        
	               }
    %>
          </table>
          <a href="add_employee_form.jsp">Add new employee.</a>
    </body>
</html>

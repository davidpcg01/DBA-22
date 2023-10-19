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
    String name = request.getParameter("name");
    String address = request.getParameter("address");
    String salaryString = request.getParameter("salary");
    String emptype = request.getParameter("emptype");
    String addl_info = request.getParameter("addl_info");
    String addl_info2 = request.getParameter("addl_info2");

    /*
     * If the user hasn't filled out all the name, address, salary, employee type and addition info correctly. 
     This is very simple checking.
     */
    if (name.equals("") || address.equals("") || salaryString.equals("") || emptype.equals("") || addl_info.equals("")) 
    {
        response.sendRedirect("add_employee_form.jsp");
    } 
    
    else if (emptype.equals("technical_staff") && addl_info2.equals("")) {
    	response.sendRedirect("add_employee_form.jsp");
    }
    else {
        float salary = Float.parseFloat(salaryString);
        
        // Now perform the query with the data from the form.
        boolean success = handler.addEmployee(emptype, name, address, salary, addl_info, addl_info2);
        if (!success) { // Something went wrong
            %>
                <h2>There was a problem inserting the employee</h2>
            <%
        } else { // Confirm success to the user
            %>
            <h2>The Employee:</h2>

            <ul>
                <li>Name: <%=name%></li>
                <li>Address: <%=address%></li>
                <li>Salary: <%=salaryString%></li>
                <li>Employee Type: <%=emptype%></li>
                <li>Additional Information: <%=addl_info%></li>
                <li>Degree: <%=addl_info2%></li>
            </ul>

            <h2>Was successfully inserted.</h2>
            
            <a href="get_emp_salary_greater_form.jsp">See all employees with a salary greater than particular salary.</a>
            <%
        }
    }
    %>
    </body>
</html>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Get Employees With Salary Above A Particular Salary</title>
    </head>
    <body>
        <h2>Get Employees With Salary Above A Particular Salary</h2>
        <!--
            Form for collecting user input for the new movie_night record.
            Upon form submission, add_movie.jsp file will be invoked.
        -->
        <form action="get_emp_salary_greater.jsp">
            <!-- The form organized in an HTML table for better clarity. -->
            <table border=1>
                <tr>
                    <th colspan="2">Enter the Salary:</th>
                </tr>
                <tr>
                    <td>Salary:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=salary>
                    </div></td>
                </tr>
                <tr>
                    <td><div style="text-align: center;">
                    <input type=reset value=Clear>
                    </div></td>
                    <td><div style="text-align: center;">
                    <input type=submit value=Insert>
                    </div></td>
                </tr>
            </table>
        </form>
    </body>
</html>

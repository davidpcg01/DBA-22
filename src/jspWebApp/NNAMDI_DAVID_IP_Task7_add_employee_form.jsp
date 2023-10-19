<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Add New Employee</title>
    </head>
    <body>
        <h2>Add New Employee</h2>
        <!--
            Form for collecting user input for the new employee record.
            Upon form submission, add_employee.jsp file will be invoked.
        -->
        <form action="add_employee.jsp">
            <!-- The form organized in an HTML table for better clarity. -->
            <table border=1>
                <tr>
                    <th colspan="2">Enter the New Employee Data:</th>
                </tr>
                <tr>
                    <td>Name:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=name>
                    </div></td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=address>
                    </div></td>
                </tr>
                <tr>
                    <td>Salary:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=salary>
                    </div></td>
                </tr>
                <tr>
                    <td>Employee Type:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=emptype>
                    </div></td>
                </tr>
                <tr>
                    <td>Additional Information:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=addl_info>
                    </div></td>
                </tr>
                <tr>
                    <td>Degree: </td>
                    <td><div style="text-align: center;">
                    <input type=text name=addl_info2>
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
        <h3>Note: </h3>
        <a>For Employee Type: Please enter "technical_staff", "quality_controller" or "worker"</a>
        <br/>
        <a>For Technical Staff: The additional information is the technical position</a>
        <br/>
        <a>For Quality Controller: The additional information is product type, please enter ("product1", "product2" or "product3")</a>
        <br/>
        <a>For Worker: The additional information is the max number of products they can make each day</a>
        <br/>
        <a>For Degree: Please enter "BSC", "MSC" or "PHD". Note that this entry is only required for technical staff</a>
    </body>
</html>

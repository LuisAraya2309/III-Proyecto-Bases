
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="conexion.conexionBD"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
        <title>Planilla Semanal</title>
    </head>
    <body>
        <h1> Últimas 15 Planillas Semanales</h1>
        
        <form action = "detallePlanillas.jsp">
            <table>
                    <tr>
                        <!-- Nombres de las columnas -->
                        <td>Id</td>
                        <td>Salario Bruto</td>
                        <td>Salario Neto</td>
                        <td>Total de Deducciones</td>
                        <td>Horas Ordinarias</td>
                        <td>Horas Extras</td>
                        <td>Horas Extras Dobles</td>
                        <td>Detalle</td>
                    </tr>
                    <%
                    try{
                        conexionBD conection = new conexionBD();
                        Connection conexion = conection.getConexion();    
                        String infoEmpleado = String.valueOf(request.getAttribute("infoEmpleado"));
                        String consultaSQL = "SELECT ValorDocumentoIdentidad FROM dbo.Empleados WHERE Nombre = " + "'"+infoEmpleado+ "'";
                        Statement stmt =  conexion.createStatement();
                        ResultSet valorDocIdentidad = stmt.executeQuery(consultaSQL);
                        int inValorDocIdentidad = 0;
                        while(valorDocIdentidad.next()){
                            inValorDocIdentidad = valorDocIdentidad.getInt(1);
                        }
                        PreparedStatement ps = conexion.prepareStatement("EXEC sp_ListarPlanillaSemanal ?,?");
                        ps.setInt(1, inValorDocIdentidad);
                        ps.setInt(2, 0);
                        ResultSet dataset = ps.executeQuery();
                        while(dataset.next()){
                            out.println("<tr>"+
                           "<td>"+ dataset.getInt("Id") +"<td>"+
                           "<td>"+ dataset.getFloat("SalarioBruto") +"<td>"+
                           "<td>"+ dataset.getFloat("SalarioNeto") +"<td>"+
                           "<td>"+ dataset.getFloat("TotalDeducciones") +"<td>"+
                           "<td>"+ dataset.getInt("HorasOrdinarias") +"<td>"+
                           "<td>"+ dataset.getInt("HorasExtra") +"<td>"+
                           "<td>"+ dataset.getInt("HorasExtraDoble") +"<td>"+
                           "<td>"+ "<input type='checkbox' name='Detalle' value='"+dataset.getInt("Id")+"'>" +"<td>"+
                           "<tr>"
                           );
                        }
                    }
                    catch(SQLException ex){
                        System.out.println(ex);
                    }

                    %>
            </table>
            
            <input type="submit" value="Detalle de Asistencias">
            
        </form>
        
        
    </body>
</html>

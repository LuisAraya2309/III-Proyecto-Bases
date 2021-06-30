
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
        <title>DetalleMensual</title>
    </head>
    <body>
        <h1>Detalle de la Planilla Mensual</h1>
        <table>
            <tr>
                <!-- Nombres de las columnas -->
                <td>Id</td>
                <td>Total de Deduccion</td>
                <td>IdPlanillaXMesXEmpleado</td>
                <td>IdTipoDeduccion</td>
            </tr>
            <%
                try{
                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();    
                    int idPlanilla = Integer.parseInt(request.getParameter("Detalle"));
                    PreparedStatement ps = conexion.prepareStatement("EXEC sp_DetalleDeduccionesMes ?,?");
                    ps.setInt(1, idPlanilla);
                    ps.setInt(2, 0);
                    ResultSet dataset = ps.executeQuery();
                    while(dataset.next()){
                        out.println("<tr>"+
                                    "<td>"+ dataset.getInt("Id") +"<td>"+
                                    "<td>"+ dataset.getFloat("TotalDeduccion") +"<td>"+
                                    "<td>"+ dataset.getInt("IdPlanillaXMesXEmpleado") +"<td>"+
                                    "<td>"+ dataset.getInt("IdTipoDeduccion") +"<td>"+
                                    "<tr>"
                                    );
                    }
                }
                catch(SQLException ex){
                    System.out.println(ex);
                }
            %>
        </table>
    </body>
</html>

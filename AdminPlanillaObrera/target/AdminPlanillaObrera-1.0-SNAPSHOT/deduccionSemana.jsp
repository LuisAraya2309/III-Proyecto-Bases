<%-- 
    Document   : deduccionSemana
    Created on : 30 jun. 2021, 15:04:42
    Author     : luist
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="conexion.conexionBD"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="conexion.conexionBD"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
        <title>Detalle Semanal de Deducciones</title>
    </head>
    <body>
        <h1>Detalle de deducciones</h1>
        <table>
            <tr>
                <!-- Nombres de las columnas -->
                <td>Id</td>
                <td>Nombre</td>
                <td>Es Obligatoria</td>
                <td>Porcentaje</td>
                <td>Monto</td>
            </tr>
            <%
                try{
                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();
                    int idPlanilla = Integer.parseInt(request.getParameter("idPlanilla"));
                    PreparedStatement ps = conexion.prepareStatement("EXEC sp_DeduccionesSemanales ?,?");
                    ps.setInt(1, idPlanilla);
                    ps.setInt(2, 0);
                    ResultSet dataset = ps.executeQuery();
                    while(dataset.next()){
                        out.println("<tr>"+
                                    "<td>"+ dataset.getInt("Id") +"<td>"+
                                    "<td>"+ dataset.getString("Nombre") +"<td>"+
                                    "<td>"+ dataset.getString("EsObligatoria") +"<td>"+
                                    "<td>"+ dataset.getFloat("Porcentage") +"<td>"+
                                    "<td>"+ dataset.getFloat("Monto") +"<td>"+
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

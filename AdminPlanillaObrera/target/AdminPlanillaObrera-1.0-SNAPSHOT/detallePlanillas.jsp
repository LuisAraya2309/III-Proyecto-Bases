
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
        <title>Detalle Planilla</title>
    </head>
    <body>
        <h1>Detalle de la Planilla Semanal</h1>
        <table>
            <tr>
                <!-- Nombres de las columnas -->
                <td>Id MarcaAsistencia</td>
                <td>FechaEntrada</td>
                <td>FechaSalida</td>
                <td>IdJornada</td>
                <td>IdMovimientoHora</td>
                <td>IdMarcaAsistencia</td>
                <td>Horas</td>
                <td>IdMovimientoPlanilla</td>
                <td>Monto</td>
                <td>IdTipoMovimientoPlanilla</td>
            </tr>
            <%
                try{
                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();    
                    int idPlanilla = Integer.parseInt(request.getParameter("Detalle"));
                    PreparedStatement ps = conexion.prepareStatement("EXEC sp_MarcaAsistenciaPlanilla ?,?");
                    ps.setInt(1, idPlanilla);
                    ps.setInt(2, 0);
                    ResultSet dataset = ps.executeQuery();
                    while(dataset.next()){
                        out.println("<tr>"+
                                    "<td>"+ dataset.getInt("MarcaDeAsistencia") +"<td>"+
                                    "<td>"+ dataset.getDate("FechaEntrada") +"<td>"+
                                    "<td>"+ dataset.getDate("FechaSalida") +"<td>"+
                                    "<td>"+ dataset.getInt("IdJornada") +"<td>"+
                                    "<td>"+ dataset.getInt("IdMovimientoHora") +"<td>"+
                                    "<td>"+ dataset.getInt("IdMarcaAsistencia") +"<td>"+
                                    "<td>"+ dataset.getInt("Horas") +"<td>"+
                                    "<td>"+ dataset.getInt("IdMovimientoPlanilla") +"<td>"+
                                    "<td>"+ dataset.getFloat("Monto") +"<td>"+
                                    "<td>"+ dataset.getInt("IdTipoMovimientoPlanilla") +"<td>"+
                                    "<tr>"
                                    );
                    }
                    
                }
                catch(SQLException ex){
                    System.out.println(ex);
                }
            %>
        </table>
        
        <form action = "deduccionSemana.jsp">
            <input type="submit" value="Deducciones de esta semana">
            <input type="hidden" name="idPlanilla" value="<%= Integer.parseInt(request.getParameter("Detalle")) %>" />
           
            
        </form>
        
    </body>
</html>

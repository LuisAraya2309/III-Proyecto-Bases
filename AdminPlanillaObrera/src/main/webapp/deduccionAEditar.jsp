
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>
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
        <title>Deduccion a Editar</title>
    </head>
    <body>
        <%
            int idDeduccion = Integer.parseInt(request.getParameter("idDeduccion"));
            float nuevoValor = Float.parseFloat(request.getParameter("nuevoValor"));
            boolean tipoMonto;
            if(request.getParameter("tipoMonto").equals("Fija No Obligatoria")){
                tipoMonto = false;
            }
            else{
            tipoMonto = true;
            }
            try{
                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_EditarMontoDeducciones ?,?,?,?";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ps.setInt(1,idDeduccion);
                ps.setFloat(2, nuevoValor);
                ps.setBoolean(3, tipoMonto);
                ps.setInt(4,0);
                ps.executeQuery();
                
                
            }
            catch(SQLException ex){
            System.out.println(ex);
            }
            out.println("<h1>Deduccion editada con exito.</h1>");
            


        %>
    </body>
</html>

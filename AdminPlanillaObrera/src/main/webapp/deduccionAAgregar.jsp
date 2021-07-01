
<%@page import="java.sql.PreparedStatement"%>
<%@page import="conexion.conexionBD"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
        <title>Deduccion agregada con exito</title>
    </head>
    <body>
        
        <%
            String valorDocIdentidad = request.getParameter("valorDocIdentidad");
            String fechaInicio = request.getParameter("fechaInicio");
            String nombreTipoDeduccion = request.getParameter("tipoDeduccion");
            float nuevoMonto = Float.parseFloat(request.getParameter("nuevoMonto"));
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
                String callSP = "EXECUTE sp_AgregarDeduccion ?,?,?,?,?,?";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ps.setString(1,valorDocIdentidad);
                ps.setString(2, fechaInicio);
                ps.setString(3, nombreTipoDeduccion);
                ps.setFloat(4,nuevoMonto);
                ps.setBoolean(5,tipoMonto);
                ps.setInt(6, 0);
                ps.executeQuery();
                
                
            }
            catch(SQLException ex){
            System.out.println(ex);
            }
            out.println("<h1>Deduccion agregada con exito.</h1>");

            
            
        %>
    </body>
</html>

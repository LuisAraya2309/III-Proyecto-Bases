
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Comprobando</title>
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" /> 
    </head>
    <body>
        <%
            try{ 
                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarUsuarios";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                HashMap<String, String> comprobar = new HashMap<>();
                while(dataset.next()){
                   comprobar.put(dataset.getString("username"),dataset.getString("password"));
                }
                if(comprobar.size()==0){
                    /*CARGABA LOS DATOS EN ESTA PARTE */
                }
                System.out.println("Ya hay datos");
                String user = request.getParameter("user");
                String password = request.getParameter("password");
                /*if(VALIDAR QUE USER Y PASSWORD EXISTA){
                    response.sendRedirect("central.html");
                }*/
                response.sendRedirect("central.html");
                /*else{
                    out.println("Usuario no registrado <a href='index.html'>Intente de nuevo</a>");
                }*/
                }catch(SQLException ex){
                    response.sendRedirect("central.html");
                }  
        %>
        
    </body>
</html>

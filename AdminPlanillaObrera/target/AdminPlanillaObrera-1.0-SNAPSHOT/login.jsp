

<%@page import="java.sql.SQLException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>
<%@page import="validaciones.validacionesSQL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Comprobando</title>
        <link href = "styleLogin.css" type = "text/css"  rel = "stylesheet" />
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
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
                   comprobar.put(dataset.getString("username"),dataset.getString("pwd"));
                }
                /*if(comprobar.size()==0){
                    System.out.println("Cargando Datos");
                    String cargarXML = "EXECUTE sp_CargarXML";
                    PreparedStatement cargar = conexion.prepareStatement(cargarXML);
                    cargar.executeQuery();
                }
                */
                System.out.println("Ya hay datos");
                String user = request.getParameter("user");
                String password = request.getParameter("password");
                if(validacionesSQL.validLogin(user, password)){
                    response.sendRedirect("central.jsp");
                }
                else{
                    out.println("Usuario no registrado <a href='index.html'>Intente de nuevo</a>");
                }
                }catch(SQLException ex){
                    System.out.println(ex);
                    //response.sendRedirect("central.jsp");
                }  
        %>
        
    </body>
</html>


<%@page import ="java.sql.SQLException"%>
<%@page import ="java.util.HashMap"%>
<%@page import ="java.sql.ResultSet"%>
<%@page import ="java.sql.PreparedStatement"%>
<%@page import ="java.sql.PreparedStatement"%>
<%@page import ="java.sql.Connection"%>
<%@page import ="conexiones.conexionBD"%>
<%@page import ="validaciones.validacionesSQL"%>
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
                System.out.println("Paso la conexion");
                String callSP = "EXECUTE sp_ListarUsuarios";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                HashMap<String, String> comprobar = new HashMap<>();
                while(dataset.next()){
                   comprobar.put(dataset.getString("username"),dataset.getString("password"));
                }
                if(comprobar.size()==0){
                    System.out.println("Cargando Datos");
                    String simulacionCarga = "EXECUTE sp_ScriptCargaXML";
                    PreparedStatement cargar = conexion.prepareStatement(simulacionCarga);
                    cargar.executeQuery();
                }
                String user = request.getParameter("user");
                String password = request.getParameter("password");
                if(validacionesSQL.validLogin(user, password)){
                    response.sendRedirect("central.html");
                }
                else{
                    out.println("Usuario no registrado <a href='index.html'>Intente de nuevo</a>");
                }
                }catch(SQLException ex){
                    response.sendRedirect("central.html");
                }  
        %>
        
    </body>
</html>

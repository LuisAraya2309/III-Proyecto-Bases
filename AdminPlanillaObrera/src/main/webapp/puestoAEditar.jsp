
<%@page import="validaciones.validacionesSQL"%>
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
        <title>Puesto Editado</title>
    </head>
    <body>
         <%
            String puestoAEditar = request.getParameter("puestoEditar");
            String nuevoNombre = request.getParameter("nuevoNombre");
            int nuevoSalario = Integer.parseInt((request.getParameter("nuevoSalario")));
            int id = Integer.parseInt(request.getParameter("nuevoId"));
            if((nuevoNombre.length()<40)&&(validacionesSQL.existePuesto(puestoAEditar))&&(!validacionesSQL.existePuesto(nuevoNombre))&&(!validacionesSQL.existePuestoID(id+""))){
                try{ 
                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();
                    String callSP = "EXECUTE sp_EditarPuesto ?,?,?";
                    PreparedStatement ps = conexion.prepareStatement(callSP);
                    ps.setString(1,puestoAEditar);
                    ps.setString(2,nuevoNombre);
                    ps.setInt(3,nuevoSalario);
                    ps.executeQuery();
                }catch(SQLException ex){
                    

                }
                out.println("<h1>Puesto editado con éxito</h1>");
                out.println("<a href='central.html'>Regresar a la central</a>");
                out.println("<a href='editarPuestos.html'>Regresar</a>");
            }
            else{
            out.println("<h1>Nombre invalido, debe de tener menos de 40 caracteres,debe existir dicho puesto a editar y el nuevo nombre no debe de estar repetido </h1>");
            out.println("<a href='editarPuestos.jsp'>Regresar a la edición de puestos</a>");
            
            } 
        %>
    </body>
</html>

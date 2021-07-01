

<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>
<%@page import="validaciones.validacionesSQL"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" /> 
        <title>Empleado a Editar</title>
    </head>
    <body>
        <%
            String nombre = request.getParameter("nombreEmpleado");
            String nuevoNombre = request.getParameter("nuevoNombre");
            String tipoDocIdentidad = request.getParameter("tipoDocIdentidad");
            int valorDocIdentidad = Integer.parseInt(request.getParameter("valorDocIdentidad"));
            String puesto = request.getParameter("puesto");
            String departamento = request.getParameter("departamento");
            System.out.println(nombre+nuevoNombre+tipoDocIdentidad+(valorDocIdentidad+""));
            if(validacionesSQL.existeEmpleadoNombre(nombre)){
                if(!validacionesSQL.existeEmpleado(valorDocIdentidad + "")){
                    if(nuevoNombre.length()<40 ){
                        try{ 
                            conexionBD conection = new conexionBD();
                            Connection conexion = conection.getConexion();
                            String callSP = "EXECUTE sp_EditarEmpleado ?,?,?,?,?,?,?";
                            PreparedStatement ps = conexion.prepareStatement(callSP);
                            ps.setString(1, nombre);
                            ps.setString(2, nuevoNombre);
                            ps.setString(3, tipoDocIdentidad);
                            ps.setInt(4, valorDocIdentidad);
                            ps.setString(5,puesto);
                            ps.setString(6, departamento);
                            ps.setInt(7, 0);
                            ps.executeQuery();
                        }catch(SQLException ex){
                            
                        }
                        out.println("<h1>Empleado editado con éxito</h1>");
                        out.println("<a href='central.jsp'>Regresar a la central</a>");
                        out.println("<a href='editarEmpleados.jsp'>Regresar a la edición de empleados</a>");
                    }
                    else{
                        out.println("<h1>El nombre ingresado es invalido, debe de tener menos de 40 caracteres. </h1>");
                        out.println("<a href='editarEmpleados.jsp'>Regresar a la edición de empleados</a>");
                    }
                }
                else{
                    out.println("<h1>El valor documento de identidad ingresado ya esta registrado en la base de datos. </h1>");
                    out.println("<a href='editarEmpleados.jsp'>Regresar a la edición de empleados</a>");
                }
            }
            else{
                out.println("<h1>El empleado que desea editar no fue encontrado en la base de datos. </h1>");
                out.println("<a href='editarEmpleados.jsp'>Regresar a la edición de empleados</a>");
            }
            
        %>
        
    </body>
</html>

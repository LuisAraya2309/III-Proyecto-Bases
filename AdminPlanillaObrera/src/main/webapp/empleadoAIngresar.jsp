<%-- 
    Document   : empleadoAIngresar
    Created on : 15 abr. 2021, 7:59:44
    Author     : luist
--%>

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
        <title>Ingresar Empleado</title>
        <link href = "styleFuncionalidades.css" type = "text/css"  rel = "stylesheet" /> 
    </head>
    <body>
        <%
            String nuevoNombre = request.getParameter("nuevoNombre");
            String tipoDocIdentidad = request.getParameter("tipoDocIdentidad");
            int valorDocIdentidad = Integer.parseInt(request.getParameter("valorDocIdentidad"));
            String fechaNacimiento = request.getParameter("fechaNacimiento");
            String puesto = request.getParameter("puesto");
            String departamento = request.getParameter("departamento");
            if(nuevoNombre.length()<40 && (!validacionesSQL.existeEmpleado(valorDocIdentidad+""))){
                if(validacionesSQL.validarFecha(fechaNacimiento)){
                    try{ 
                            conexionBD conection = new conexionBD();
                            Connection conexion = conection.getConexion();
                            String callSP = "EXECUTE sp_InsertarEmpleado ?,?,?,?,?,?";
                            PreparedStatement ps = conexion.prepareStatement(callSP);
                            ps.setString(1, nuevoNombre);
                            ps.setString(2, tipoDocIdentidad);
                            ps.setInt(3, valorDocIdentidad);
                            ps.setString(4, fechaNacimiento);
                            ps.setString(5,puesto);
                            ps.setString(6, departamento);
                            ps.executeQuery();
                        }catch(SQLException ex){
                            System.out.println(ex);
                        }
                        out.println("<h1>Empleado insertado con éxito</h1>");
                        out.println("<a href='central.html'>Regresar a la central</a>");
                        out.println("<a href='insertarEmpleado.html'>Regresar a la inserción  de empleados</a>");
                    }
                    else{
                        out.println("<h1>Formato de fecha inválido </h1>");
                        out.println("<a href='insertarEmpleado.jsp'>Regresar a la inserción de empleados</a>");
                    }
                }
            else{
                out.println("<h1>El nombre debe de tener menos de 40 caracteres y el valor de documento de identidad no debe de estar repetido</h1>");
                out.println("<a href='editarEmpleados.jsp'>Regresar a la edición de empleados</a>");
            }
        %>
    </body>
</html>

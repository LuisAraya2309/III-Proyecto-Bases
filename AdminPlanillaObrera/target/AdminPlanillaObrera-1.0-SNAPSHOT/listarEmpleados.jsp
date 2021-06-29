

<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
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
        <title>Listar Empleados</title>
    </head>
    <body>
        <h1>Empleados: </h1>
        <form action="editarEmpleados.jsp">
            <select name="empleado" id="empleado">
           <%
            try{ 
                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarEmpleados";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                List<String> empleadosConvertidos = new ArrayList<>();
                while(dataset.next()){
                    String empleadoConstruir ="";
                    empleadoConstruir+= "Nombre: " + dataset.getString("Nombre") + 
                    " ,Fecha de nacimiento: " + 
                    dataset.getString("fechaNacimiento")+
                    " ,Tipo documento ID: "+ 
                    dataset.getString(3)+
                    " ,Valor documento de ID: "+ 
                    dataset.getString("valorDocIdentidad")+
                    " ,Puesto: "+
                    dataset.getString(5)+ 
                    " ,Departamento: "+ 
                    dataset.getString(6) ;
                    empleadosConvertidos.add(empleadoConstruir);
                }
                int size = empleadosConvertidos.size();
                for(int i =0;i<size;i++){
                    out.println("<option>"+empleadosConvertidos.get(i)+"</option>");
               }
               
            }catch(SQLException ex){
               System.out.println(ex);
            } 
            %>
        </select>
        
        <input type="submit" name="editar" id="editar" value="Editar">
        </form>
        <a href='central.html'>Regresar a la central</a>
    </body>
</html>

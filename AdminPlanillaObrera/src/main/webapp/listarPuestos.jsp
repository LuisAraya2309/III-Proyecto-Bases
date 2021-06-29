
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
        <title>Listar Puestos</title>
    </head>
    <body>
        <h1>Puestos: </h1>
        <form action="editarPuestos.jsp">
            <select name="puesto" id="puesto">
           <%
            try{ 

                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarPuestos";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                List<String> puestosConvertidos = new ArrayList<>();
                while(dataset.next()){
                   String puestoCompleto ="";
                   puestoCompleto +="Nombre: "+dataset.getString("Nombre")+" , Salario por Hora: "+dataset.getString("SalarioXHora");
                   puestosConvertidos.add(puestoCompleto);
                }
                int size = puestosConvertidos.size();
                for(int i =0;i<size;i++){
                out.println("<option>"+puestosConvertidos.get(i)+"</option>");
               }

            }catch(SQLException ex){
               
            } 
            %>
        </select>
        <input type="submit" name="editar" id="editar" value="Editar">
        </form>
        <a href='central.html'>Regresar a la central</a>
    </body>
</html>

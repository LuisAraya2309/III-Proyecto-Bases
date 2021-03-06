
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
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
        <title>Editar Empleados</title>
    </head>
    <body>
        <form action="empleadoAEditar.jsp">
            <% String empleadoSeleccionado  = String.valueOf(request.getAttribute("infoEmpleado"));
                String empleadoActualizado =""; 
                if(empleadoSeleccionado!=null){
                    String[] infoEmpleado = empleadoSeleccionado.split(" ");
                    empleadoActualizado = infoEmpleado[0] +" "+ infoEmpleado[1] + " " +infoEmpleado[2];
                }
                else{
                empleadoActualizado = "";
                }
            %>
            Nombre Empleado a editar: <input type="text" name="nombreEmpleado" value="<%= empleadoActualizado%>" required="">
            Nuevo Nombre: <input type="text" name="nuevoNombre" required="">
            Tipo de Documento de Identidad: <select name="tipoDocIdentidad" id="tipoDocIdentidad" required="">
                <% try{ 
                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarTipoDocIdentidad";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                List<String> docsConvertidos = new ArrayList<>();
                while(dataset.next()){
                   String tipoDoc ="";
                   tipoDoc +=dataset.getString("Nombre");
                   docsConvertidos.add(tipoDoc);
                }
                int size = docsConvertidos.size();
                for(int i =0;i<size;i++){
                out.println("<option>"+docsConvertidos.get(i)+"</option>");
               }
            }catch(SQLException ex){
               System.out.println(ex);
            } 
            %>
            </select>
            
           Valor de documento de identidad: <input type="text" name="valorDocIdentidad" required="">
           
           Puesto:
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
                   puestoCompleto+=dataset.getString("Nombre");
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
           
           Departamento:<select name="departamento" id="departamento" required="">
           <% try{ 
                conexionBD conection = new conexionBD();
                Connection conexion = conection.getConexion();
                String callSP = "EXECUTE sp_ListarDepartamento";
                PreparedStatement ps = conexion.prepareStatement(callSP);
                ResultSet dataset = ps.executeQuery();
                List<String> docsConvertidos = new ArrayList<>();
                while(dataset.next()){
                   String tipoDoc ="";
                   tipoDoc +=dataset.getString("Nombre");
                   docsConvertidos.add(tipoDoc);
                }
                int size = docsConvertidos.size();
                for(int i =0;i<size;i++){
                out.println("<option>"+docsConvertidos.get(i)+"</option>");
               }
            }catch(SQLException ex){
               
            } 
            %>
           </select>
            
           <input type="submit" name="editar" id="editar" value="Editar">
        </form>
        <a href='central.jsp'>Regresar a la central</a>
    </body>
</html>

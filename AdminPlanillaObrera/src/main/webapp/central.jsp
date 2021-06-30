
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="conexion.conexionBD"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Administrar Sistema Obrero</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href = "styleCentral.css" type = "text/css"  rel = "stylesheet" />
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
    </head>
    <body>
        <h1>
            Funcionalidades del Sistema
        </h1>                   
        <div>
            <form action = "decidirFuncionalidad.jsp">
                Empleados:  <select name="empleados" id="empleados" required="">
                <% try{ 
                    conexionBD conection = new conexionBD();
                    Connection conexion = conection.getConexion();
                    String callSP = "EXECUTE sp_ListarEmpleados";
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
               
               <select name = "funcionalidad" id = "funcionalidad" required="">
                   <option>Historial</option>
                   <option>Editar Empleado</option>
                   <option>Editar Deducciones</option>
                   <option>Ver Planillas Semanales</option>
                   <option>Ver Planillas Mensuales</option>
               </select>
               <input type="submit" name="Ir" id="Ir" value="Ir">
            </form>
        </div>
    </body>
        
</html>

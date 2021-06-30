
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
                       
        <div>
            <form>
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
            </form>
        </div>


        <div>
            <form action="historial.jsp">
                <input type="submit" name="historial" id="historial" value="Historial">
            </form>
        </div>    

        <div>
            <form action="editarEmpleados.jsp">
                <input type="submit" name="editarEmpleado" id="editarEmpleado" value="Editar empleado">
            </form>
        </div>

        <div>
            <form action="editarDeducciones.jsp">
                <input type="submit" name="editarDeducciones" id="editarDeducciones" value="Editar Deducciones">
            </form>

        </div>


        <div>
            <form action="planillaSemana.jsp">
                <input type="submit" name="planillaSemanales" id="planillaSemanales" value="Planillas semanales">
            </form>
        </div>

        <div>
            <form action="planillaMensual.jsp">
                <input type="submit" name="planillasMensuales" id="planillasMensuales" value="Planillas mensuales">
            </form>
        </div>
                       
        
    </body>
        
</html>

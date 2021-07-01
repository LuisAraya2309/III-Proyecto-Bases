

<%@page import="java.sql.Statement"%>
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
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link href="https://fonts.googleapis.com/css2?family=KoHo:wght@200&display=swap" rel="stylesheet">
        <title>Editar Deducciones</title>
    </head>
    <body>
        <h1>Deducciones del Empleado No Obligatorias</h1>
        <form action = "decidirDeduccion.jsp">
            <select name = "infoDeduccion" id = "infoDeduccion" required="">
                <%  try{
                        String infoEmpleado = String.valueOf(request.getAttribute("infoEmpleado"));
                        conexionBD conection = new conexionBD();
                        Connection conexion = conection.getConexion();
                        String consultaSQL = "SELECT ValorDocumentoIdentidad FROM dbo.Empleados WHERE Nombre = " + "'"+infoEmpleado+ "'";
                        Statement stmt =  conexion.createStatement();
                        ResultSet valores = stmt.executeQuery(consultaSQL);
                        int inValorDocIdentidad = 0;
                        while(valores.next()){
                            inValorDocIdentidad = valores.getInt(1);
                        }
                        System.out.println(inValorDocIdentidad);
                        PreparedStatement ps = conexion.prepareStatement("EXEC sp_ListarDeduccionXEmpleado ?");
                        ps.setInt(1, inValorDocIdentidad);
                        ResultSet dataset = ps.executeQuery();
                        while(dataset.next()){
                            if( dataset.getFloat("MontoFijaNoO") != 0.0){
                                out.println("<option>"+
                                                "Id: "+ dataset.getInt("Id")+ " "+
                                                "FechaInicio: " +dataset.getDate("FechaInicio")+ " "+
                                                "NombreDeduccion: " + dataset.getString("NombreTipoDedu")+ " "+
                                                "Monto: "+dataset.getFloat("MontoFijaNoO")+ " "+
                                                "</option>");
                            }
                            else if(dataset.getFloat("PorcentajeNoObligatoria") != 0.0){
                                out.println("<option>"+
                                                "Id: "+dataset.getInt("Id")+ " "+
                                                "FechaInicio: " + dataset.getDate("FechaInicio")+ " "+
                                                "NombreDeduccion: " +dataset.getString("NombreTipoDedu")+ " "+
                                                "Porcentaje: " +dataset.getFloat("PorcentajeNoObligatoria")+ " "+
                                                "</option>");
                            }
                        }
                    }
                    catch(SQLException ex){
                        
                    }
                %>
            </select>
                <select name = "funcionalidad" id = "funcionalidad" required="">
                   <option>Agregar Deduccion</option>
                   <option>Editar Deduccion</option>
                   <option>Eliminar Deduccion</option>
                </select>
                <input type="submit" name="Ir" id="Ir" value="Ir">
            
            
        
        </form>
    </body>
</html>

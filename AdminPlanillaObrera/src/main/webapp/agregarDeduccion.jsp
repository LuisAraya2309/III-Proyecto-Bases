

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Statement"%>
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
        <title>Agregar deduccion</title>
    </head>
    <body>
        <form action="deduccionAAgregar.jsp">
        <%
            String infoDeduccionCompleto = request.getParameter("infoDeduccion");
            int idDeduccion = Integer.parseInt(infoDeduccionCompleto.split(" ")[1]);
            System.out.println(idDeduccion);
            
            conexionBD conection = new conexionBD();
            Connection conexion = conection.getConexion();
            String consultaSQL = "SELECT ValorDocumentoIdentidad FROM dbo.Empleados AS E WHERE E.Id  = "
                    + "(SELECT TOP(1) DE.IdEmpleado FROM DeduccionXEmpleado AS DE WHERE DE.Id =" +idDeduccion+")";
            
            Statement stmt =  conexion.createStatement();
            ResultSet valores = stmt.executeQuery(consultaSQL);
            int valorDocIdentidad = 0;
            while(valores.next()){
                valorDocIdentidad = valores.getInt(1);
            }
            System.out.println(valorDocIdentidad);
        %>
        Valor Documento Identidad: <input type="text" name="valorDocIdentidad" value="<%= valorDocIdentidad%>" required="">
        FechaInicio: <input type="text" name="fechaInicio" required="">
        Nombre del Tipo Deduccion: <input type="text" name="tipoDeduccion" required="">
        Nuevo Monto: <input type="text" name="nuevoMonto" required="">
        Tipo Monto: 
        <select name = "tipoMonto" required="">
            <option>Fija No Obligatoria</option>
            <option>Porcentual No Obligatoria</option>
        </select>
        
        <input type="submit" value="Agregar">
        </form>
    </body>
</html>

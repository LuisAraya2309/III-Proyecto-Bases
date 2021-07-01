
<%@page import="java.sql.ResultSet"%>
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
        <title>Editar Deduccion</title>
    </head>
    
    <body>
        <form action="deduccionAEditar.jsp">
             <%
            String infoDeduccionCompleto = request.getParameter("infoDeduccion");
            int idDeduccion = Integer.parseInt(infoDeduccionCompleto.split(" ")[1]);
            System.out.println(idDeduccion);
            %>
            IdDeduccion: <input type="text" name="idDeduccion" value="<%= idDeduccion%>" required="">
            NuevoValor: <input type="text" name="nuevoValor" required="">
            Tipo Monto: 
            <select name = "tipoMonto" required="">
                <option>Fija No Obligatoria</option>
                <option>Porcentual No Obligatoria</option>
            </select>
            <input type="submit" value="Editar">
        </form>
    </body>
</html>


<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Decidir Funcion de Deduccion</title>
    </head>
    <body>
        <%    
        HashMap<String, String> funcionalidades = new HashMap<>();
        //Llenar el hash
        funcionalidades.put("Agregar Deduccion", "agregarDeduccion.jsp");
        funcionalidades.put("Editar Deduccion", "editarMontoDeduccion.jsp");
        funcionalidades.put("Eliminar Deduccion", "eliminarDeduccion.jsp");
        
        request.setAttribute("infoDeduccion", new String(request.getParameter("infoDeduccion")));   
        System.out.println(request.getParameter("infoDeduccion"));
        request.getRequestDispatcher(funcionalidades.get(request.getParameter("funcionalidad"))).forward(request, response);
        %>
    </body>
</html>

package conexiones;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class conexionBD {
     //Atributes
    private Connection conexion;
 
    public conexionBD(){
          try{
              String conexionUrl = "jdbc:sqlserver://localhost:1433;databaseName=SistemaObrero;user=sa;password=admin";
              Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
              try{
                  Connection con =  DriverManager.getConnection(conexionUrl);
                  this.conexion = con;
                  System.out.println("Hizo conexion");
              } catch(SQLException ex){
                  System.out.println(ex.toString());
              }
          } catch(ClassNotFoundException ex){
              Logger.getLogger(conexionBD.class.getName()).log(Level.SEVERE, null, ex);
          }
          
    }
    
    public void setConexion(Connection conexion) {
        this.conexion = conexion;
    }
    
    public Connection getConexion() {
        return conexion;
    }
        
}

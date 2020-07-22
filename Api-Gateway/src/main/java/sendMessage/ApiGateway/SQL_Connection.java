package sendMessage.ApiGateway;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SQL_Connection {
	
	static String myUrl = "jdbc:sqlserver://sendmessagedbserver.database.windows.net:1433;database=SendMessageDB";
	static String DB_Name="tegosadmin";
	static String DB_PW="Sich??heit30";
	
	public static void SaveUser(Boolean active,String name, String password,String roles,String username) throws Exception {
		
		try
	    {
	      
			
			Connection conn = DriverManager.getConnection(myUrl, DB_Name,DB_PW );
	    
	      String query = " insert into authenticate_user (active,name,password,roles,username)"
	        + " values (?,?,?,?,?)";

	      
	      PreparedStatement preparedStmt = conn.prepareStatement(query);
	      
	      preparedStmt.setBoolean   (1, active);
	      preparedStmt.setString   (2, name);
	      preparedStmt.setString (3, password);
	      preparedStmt.setString   (4, roles);
	      preparedStmt.setString   (5, username);
	      
	      
	   
	      preparedStmt.execute();
	      
	      conn.close();
	    }
	    catch (Exception e)
	    {
	      System.err.println("Got an exception!");
	      System.err.println(e.getMessage());
	    }
	  }
	
	
}

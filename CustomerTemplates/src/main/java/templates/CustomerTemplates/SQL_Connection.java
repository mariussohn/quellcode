package templates.CustomerTemplates;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class SQL_Connection {

		public static void insertTemplate(String template, String name, int template_id, String username)  {
		try
	    {
	      
	      
	      String myUrl = "jdbc:sqlserver://tegos-sendmessage.database.windows.net:1433;database=SQL DB";
	      Connection conn = DriverManager.getConnection(myUrl, "tegos-admin", "Sich??heit30");
	    
	      String query = " insert into templates (template,name,template_id,username)"
	        + " values ( ?, ?, ?, ?)";

	      
	      PreparedStatement preparedStmt = conn.prepareStatement(query);
	      preparedStmt.setString (1, template);
	      preparedStmt.setString   (2, name);
	      preparedStmt.setInt(3, template_id);
	      preparedStmt.setString   (4, username);
	     
	   
	      preparedStmt.execute();
	      
	      conn.close();
	    }
	    catch (Exception e)
	    {
	      System.err.println("Got an exception!");
	      System.err.println(e.getMessage());
	    }
	  }
	  public static void deleteTemplate( String name, int template_id)  {
			try
		    {
		      
		      
		      String myUrl = "jdbc:sqlserver://tegos-sendmessage.database.windows.net:1433;database=SQL DB";
		      Connection conn = DriverManager.getConnection(myUrl, "tegos-admin", "Sich??heit30");
		    
		      String query = "DELETE templates FROM templates WHERE template_id='" + template_id + "' AND name = '" + name + "'";

		      Statement stmt = conn.createStatement();
		     stmt.executeUpdate(query);
		      
		      conn.close();
		    }
		    catch (Exception e)
		    {
		      System.err.println("Got an exception!");
		      System.err.println(e.getMessage());
		    }
		  }
	 
}

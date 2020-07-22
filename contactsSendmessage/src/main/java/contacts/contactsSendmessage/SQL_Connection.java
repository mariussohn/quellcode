package contacts.contactsSendmessage;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SQL_Connection {
	
	static String myUrl = "jdbc:sqlserver://sendmessagedbserver.database.windows.net:1433;database=SendMessageDB";
	static String DB_Name="tegosadmin";
	static String DB_PW="Sich??heit30";
	
	public static void SaveDataInSmsDB(String name, String customer_number,String text,String date) throws Exception {
		
		try
	    {
	      
			
			Connection conn = DriverManager.getConnection(myUrl, DB_Name,DB_PW );
	    
	      String query = " insert into smscontact (name,customer_number,text,date)"
	        + " values ( ?, ?, ?,?)";

	      
	      PreparedStatement preparedStmt = conn.prepareStatement(query);
	      
	      preparedStmt.setString   (1, name);
	      preparedStmt.setString (2, customer_number);
	      preparedStmt.setString   (3, text);
	      preparedStmt.setString   (4, date);
	      
	      
	   
	      preparedStmt.execute();
	      
	      conn.close();
	    }
	    catch (Exception e)
	    {
	      System.err.println("Got an exception!");
	      System.err.println(e.getMessage());
	    }
	  }
	
	  public static void SaveDataInDatabase(String name, int template,String customer_phone_number,String phone_number,String date) throws Exception {
		
		try
	    {
	      
	      
			Connection conn = DriverManager.getConnection(myUrl, DB_Name,DB_PW );
	    
	      String query = " insert into contact (customer_phone_number,phone_number,template,name,time_stamp)"
	        + " values ( ?, ?, ?, ?,?)";

	      
	      PreparedStatement preparedStmt = conn.prepareStatement(query);
	      preparedStmt.setString (1, customer_phone_number);
	      preparedStmt.setString   (2, phone_number);
	      preparedStmt.setInt(3, template);
	      preparedStmt.setString   (4, name);
	      preparedStmt.setString    (5, date);
	   
	      preparedStmt.execute();
	      
	      conn.close();
	    }
	    catch (Exception e)
	    {
	      System.err.println("Got an exception!");
	      System.err.println(e.getMessage());
	    }
	  }
	  
		public static int maxId() throws Exception {

			Connection conn = DriverManager.getConnection(myUrl, DB_Name,DB_PW );
			
			Statement st = conn.createStatement();

			st = conn.createStatement();
			ResultSet rs = st.executeQuery("  SELECT MAX(contact_id)from contact ");

			int max=0;
			while (rs.next()) {
				 max = rs.getInt(1);

			}

			rs.close();
			st.close();
			conn.close();
			
			return max;

		}
		public static String findRightTemplate(String name, int template_id) throws Exception {
			
			Connection conn = DriverManager.getConnection(
					myUrl, DB_Name,DB_PW );
			Statement st = conn.createStatement();

			st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT template FROM templates WHERE template_id='" + template_id + "' AND name = '" + name + "'");

			String temp="";
			while(rs.next())
			{
				temp=rs.getString("template");
			}
			
			
			rs.close();
			st.close();
			conn.close();
			
			return temp;

		}
}


package ocspring2;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.JOptionPane;

import be.mxs.common.util.db.MedwanQuery;


public class Db {

   public static Connection conn = null;

   public static void Connect() {
	   conn = MedwanQuery.getInstance().getIkireziConnection();
   }

   public static void runsql(String mysql) {
      try {
         PreparedStatement pst = conn.prepareStatement(mysql);
         pst.executeUpdate();

         pst.close();

      } catch (SQLException ex) {
         ex.printStackTrace();
      }

   }

   public static int get_integer(String mysql) {
      int i = 0;
      try {

         Statement st;

         st = conn.createStatement();

         ResultSet rs = st.executeQuery(mysql);
         while (rs.next()) {
            i = rs.getInt(1);
         }
         rs.close();
         st.close();

      } catch (SQLException ex) {
         System.err.println("Error" + ex);
      }
      return i;

   }

   public static String get_string(String mysql) {
      String s = "";
      try {

         Statement st;

         st = conn.createStatement();

         ResultSet rs = st.executeQuery(mysql);
         while (rs.next()) {
            s = rs.getString(1);
         }
         rs.close();
         st.close();

      } catch (SQLException ex) {
         System.err.println("Error" + ex);
      }
      return s;

   }

   @SuppressWarnings("finally")
public static double get_float(String mysql) {
      double i = 0.0;
      try {
         Statement st;
         st = conn.createStatement();
         ResultSet rs = st.executeQuery(mysql);
         while (rs.next()) {
            i = rs.getDouble(1);
         }
         rs.close();
         st.close();
      } 
      catch (SQLException ex) {
         System.err.println("Error" + ex);
      } 
      finally {
         return i;
      }
   }
}

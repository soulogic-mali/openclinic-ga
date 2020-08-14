package be.mxs.common.util.io;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Vector;

import net.admin.AdminFunction;
import net.admin.AdminPerson;
import net.admin.AdminPrivateContact;
import net.admin.Label;
import net.admin.Service;
import net.admin.User;

public class CCBRTCsvImporter{

    public static void main(String[] args) throws ClassNotFoundException, SQLException{
        // TODO Auto-generated method stub
        String sFilename = args[0];
        System.out.println("Importing data from "+sFilename);
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	    Connection connection = DriverManager.getConnection("jdbc:sqlserver://openclinic-db:1433;databaseName=ocadmin;user=openclinic;password=0pen/4391");
	    //Connection connection = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=ocadmin;user=sa;password=cbmt");
	    int pid=0;
	    PreparedStatement p1 = connection.prepareStatement("select max(personid) pid from admin");
	    ResultSet r1 = p1.executeQuery();
	    if(r1.next()){
	    	pid=r1.getInt("pid");
	    }
        try{
            BufferedReader reader = new BufferedReader(new FileReader(new File(sFilename)));
            String line;
            int counter=0;
            while((line = reader.readLine()) != null){
                counter++;
                if(counter>1){
                	if(counter%200==0){
                		connection.close();
                		System.out.println("RESET CONNECTION #############################################");
                	    //connection = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=ocadmin;user=sa;password=cbmt");
                		connection = DriverManager.getConnection("jdbc:sqlserver://openclinic-db:1433;databaseName=ocadmin;user=openclinic;password=0pen/4391");
                	}
                    String[] fields = line.split("\\|");
                    while(fields.length<21){
                    	line+=" "+reader.readLine();
                    	fields = line.split("\\|");
                    }
                    String personid = fields[0];
                    String immatnew = fields[1];
                    String firstname = fields[5].toUpperCase();
                    String middlename = fields[6].toUpperCase();
                    String lastname = fields[7].toUpperCase();
                    Date dateofbirth = null;
                    try{
                    	if(fields[9].length()>9){
                    		dateofbirth=new SimpleDateFormat("yyyy-MM-dd").parse(fields[9].substring(0, 10));
                    	}
                    }
                    catch(Exception e){e.printStackTrace();}
                    String gender = fields[10];
                    String box = fields[11]; //box
                    String address = fields[12]; //location
                    String telephone = fields[13];
                    String profession = fields[14];
                    String relative = fields[15];
                    String referred = fields[20];
                    System.out.println(counter+": Adding "+lastname.toUpperCase()+", "+firstname+" ("+personid+")");
                    if(lastname.trim().length()>0){
	                    //Store admin record
	            	    PreparedStatement ps = connection.prepareStatement("insert into admin("
	            	    		+ "personid,"
	            	    		+ "immatnew,"
	            	    		+ "lastname,"
	            	    		+ "firstname,"
	            	    		+ "searchname,"
	            	    		+ "dateofbirth,"
	            	    		+ "gender,"
	            	    		+ "comment3,"
	            	    		+ "language,"
	            	    		+ "updatetime,"
	            	    		+ "updateuserid,"
	            	    		+ "sourceid,"
	            	    		+ "begindate)"
	            	    		+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
	            	    ps.setInt(1,Integer.parseInt(personid));
	            	    ps.setString(2, immatnew);
	            	    ps.setString(3, lastname.toUpperCase());
	            	    ps.setString(4, firstname.toUpperCase()+" "+middlename.toUpperCase());
	            	    ps.setString(5, (lastname.toUpperCase()+","+firstname.toUpperCase()+middlename.toUpperCase()).replaceAll(" ", "").replaceAll("-", "").replaceAll("'", ""));
	                    if(dateofbirth!=null && dateofbirth.before(new java.util.Date()) && dateofbirth.after(new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1900"))){
	                    	ps.setDate(6, new java.sql.Date(dateofbirth.getTime()));
	                    }
	                    else{
	                    	ps.setDate(6, null);
	                    }
	            	    ps.setString(7, gender);
	            	    ps.setString(8, relative);
	            	    ps.setString(9, "EN");
	            	    ps.setTimestamp(10, new java.sql.Timestamp(new java.util.Date().getTime()));
	            	    ps.setString(11, "4");
	            	    ps.setString(12,"1");
	            	    ps.setTimestamp(13, new java.sql.Timestamp(new java.util.Date().getTime()));
	            	    ps.execute();
	            	    ps.close();
	            	    //Store adminprivate record
	            	    ps = connection.prepareStatement("insert into adminprivate("
	            	    		+ "privateid,"
	            	    		+ "personid,"
	            	    		+ "start,"
	            	    		+ "type,"
	            	    		+ "address,"
	            	    		+ "telephone,"
	            	    		+ "businessfunction,"
	            	    		+ "updatetime,"
	            	    		+ "updateserverid)"
	            	    		+ " values(?,?,?,?,?,?,?,?,?)");
	                    ps.setInt(1, Integer.parseInt(personid));
	                    ps.setInt(2, Integer.parseInt(personid));
	            	    ps.setTimestamp(3, new java.sql.Timestamp(new java.util.Date().getTime()));
	            	    ps.setString(4, "M");
	            	    ps.setString(5, address);
	            	    ps.setString(6, telephone);
	            	    ps.setString(7, profession);
	            	    ps.setTimestamp(8, new java.sql.Timestamp(new java.util.Date().getTime()));
	            	    ps.setInt(9, 1);
	            	    ps.execute();
	            	    ps.close();
                    }
                }
            }
        }
        catch(Exception e){
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}

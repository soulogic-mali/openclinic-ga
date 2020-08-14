package be.openclinic.system;

import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.OrangeVaccinations;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Queue;
import be.openclinic.pharmacy.Product;

public class PreLoader implements Runnable{
	Thread thread;
	static boolean isActive = false;
	
	public PreLoader(){
		thread = new Thread(this);
		thread.start();
	}
	
	public static boolean isActive(){
		return isActive;
	}
	
	public void run() {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
        try{
        	isActive=true;
        	conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
        	ps = conn.prepareStatement("select distinct oc_stock_productuid from oc_productstocks");
        	rs = ps.executeQuery();
        	while(rs.next()){
        		try{
        			Double dTest = Double.parseDouble(rs.getString("oc_stock_productuid"));
            		Product product = Product.get(rs.getString("oc_stock_productuid"));
            		if(product!=null){
            			double d = product.getLastYearsAveragePrice(ScreenHelper.endOfDay(new java.util.Date()));
            			d = product.getLooseLastYearsAveragePrice(ScreenHelper.endOfDay(new java.util.Date()));
            		}
        		}
        		catch(Exception de){}
        	}
        }
        catch (Exception e) {
			e.printStackTrace();
		}
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
	}
	
}


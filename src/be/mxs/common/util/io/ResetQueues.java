package be.mxs.common.util.io;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Mail;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.finance.Insurar;

public class ResetQueues {

	public static void main(String[] args) {
		try{
			// This will load the MySQL driver, each DB has its own driver
		    System.out.println("driver="+args[0]);
		    System.out.println("url="+args[1]);
		    Class.forName(args[0]);			
		    Connection conn =  DriverManager.getConnection(args[1]);
			PreparedStatement ps = conn.prepareStatement("update oc_queues set oc_queue_end=?, oc_queue_endreason='99', oc_queue_enduid='4' where oc_queue_subjecttype='patient' and oc_queue_end is null");
			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.execute();
			ps.close();
			ps=conn.prepareStatement("update oc_counters set oc_counter_value=0 where oc_counter_name='QUEUETICKETNUMBER'");
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
}

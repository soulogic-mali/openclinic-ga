package be.mxs.common.util.io;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import javax.ws.rs.core.Response;

import ocdhis2.DHIS2Server;
import ocdhis2.DataValue;
import ocdhis2.DataValueSet;
import ocdhis2.ImportSummary;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.auth.*;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import net.admin.User;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Mail;
import be.mxs.common.util.system.Pointer;

public class ExportDHIS2 {

	/**
	 * @param args
	 * @throws ClassNotFoundException 
	 * @throws SQLException 
	 */
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
	    Class.forName("com.mysql.jdbc.Driver");			
	    Connection conn =  DriverManager.getConnection("jdbc:mysql://localhost:3306/ocstats_dbo?"+args[0]);
	    String sql = "select distinct dc_diagnosisvalue_serverid,dc_diagnosisvalue_year,dc_diagnosisvalue_month,dc_diagnosisvalue_serviceuid from dc_dhis2deathdiagnosisvalues where dc_diagnosisvalue_dhis2exportdatetime is null order by dc_diagnosisvalue_serverid,dc_diagnosisvalue_year,dc_diagnosisvalue_month,dc_diagnosisvalue_serviceuid";
	    PreparedStatement ps = conn.prepareStatement(sql);
	    ResultSet rs =ps.executeQuery();
	    while(rs.next()){
	    	String entity = rs.getString("dc_diagnosisvalue_serverid")+";"+rs.getString("dc_diagnosisvalue_year")+";"+rs.getString("dc_diagnosisvalue_month")+";"+rs.getString("dc_diagnosisvalue_serviceuid");
			ExportDHIS2CausesOfDeath.run(args,entity);
	    }
	    rs.close();
	    ps.close();
	    sql = "select distinct dc_diagnosisvalue_serverid,dc_diagnosisvalue_year,dc_diagnosisvalue_month,dc_diagnosisvalue_serviceuid from dc_dhis2diagnosisvalues where dc_diagnosisvalue_dhis2exportdatetime is null order by dc_diagnosisvalue_serverid,dc_diagnosisvalue_year,dc_diagnosisvalue_month,dc_diagnosisvalue_serviceuid";
	    ps = conn.prepareStatement(sql);
	    rs =ps.executeQuery();
	    while(rs.next()){
	    	String entity = rs.getString("dc_diagnosisvalue_serverid")+";"+rs.getString("dc_diagnosisvalue_year")+";"+rs.getString("dc_diagnosisvalue_month")+";"+rs.getString("dc_diagnosisvalue_serviceuid");
			ExportDHIS2Diagnoses.run(args,entity);
	    }
	    rs.close();
	    ps.close();
	    conn.close();
	}
}

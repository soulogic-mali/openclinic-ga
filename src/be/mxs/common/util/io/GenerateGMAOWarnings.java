package be.mxs.common.util.io;

import java.awt.image.BufferedImage;
import java.io.File;
import java.net.URL;
import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.dcm4che2.data.DicomObject;
import org.dcm4che2.data.Tag;
import org.dcm4che2.data.VR;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.archiving.DcmSnd;
import be.openclinic.archiving.Dicom;
import be.openclinic.assets.MaintenancePlan;
import be.openclinic.reporting.MessageNotifier;
import be.openclinic.system.SH;
import uk.org.primrose.vendor.standalone.PrimroseLoader;

public class GenerateGMAOWarnings {
    public static String getParam(String[] args,String name, String defaultValue) {
    	for(int n=0;n<args.length;n++) {
    		if(args[n].equals(name) && n<args.length-1) {
    			return args[n+1];
    		}
    	}
    	return defaultValue;
    }

    public static void main(String[] args) {
		// TODO Auto-generated method stub
    	long day = 24*3600*1000;
    	int totalPlans=0;
    	try {
			PrimroseLoader.load(getParam(args, "--config", "/var/tomcat/conf/db.cfg"), true);
			
			if(getParam(args,"--debug" ,"1").equalsIgnoreCase("1")) {
				Debug.enabled=true;
			}
			String[] intervals = SH.cs("gmao.warning.intervals", "7,3").split(",");
			Connection conn = MedwanQuery.getInstance(false).getOpenclinicConnection();
			MedwanQuery.getInstance().reloadLabels();
			Hashtable hMessages = new Hashtable(),hPlanUids=new Hashtable();
			for(int n=0;n<intervals.length;n++) {
				int interval = Integer.parseInt(intervals[n]);
				PreparedStatement ps = conn.prepareStatement("select count(*) total from oc_maintenanceplans");
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					totalPlans = rs.getInt("total");
				}
				rs.close();
				ps.close();
				ps = conn.prepareStatement("select oc_maintenanceplan_planmanager,oc_maintenanceplan_serverid,oc_maintenanceplan_objectid,oc_maintenanceplan_lastreminder,oc_maintenanceplan_startdate,(select max(oc_maintenanceoperation_nextdate) nextdate from oc_maintenanceoperations o where oc_maintenanceoperation_maintenanceplanuid=oc_maintenanceplan_serverid||'.'||oc_maintenanceplan_objectid) nextdate from oc_maintenanceplans");
				rs = ps.executeQuery();
				int planCounter=0;
				System.out.println();
				while(rs.next()) {
					planCounter++;
					if(planCounter%(totalPlans/100)==0) {
						System.out.print("\r"+(planCounter*100/totalPlans)+"%");
					}
					//Check next maintenance day
					String planuid = rs.getInt("oc_maintenanceplan_serverid")+"."+rs.getInt("oc_maintenanceplan_objectid");
					java.util.Date nextOperationDate = null;
					if(rs.getDate("nextdate")!=null) {
						nextOperationDate= rs.getDate("nextdate");
					}
					else if(SH.ci("enableBlankMaintenancePlanWarnings", 0)==1) {
						nextOperationDate = rs.getDate("oc_maintenanceplan_startdate");
					}
					if(nextOperationDate!=null) {
						if(rs.getTimestamp("oc_maintenanceplan_lastreminder")==null || rs.getTimestamp("oc_maintenanceplan_lastreminder").before(new java.util.Date(nextOperationDate.getTime()-interval*day))) {
							//Should send warning if planManager configured
							String planManager = SH.c(rs.getString("oc_maintenanceplan_planmanager"));
							if(planManager.equalsIgnoreCase("frank@ict4d.be") && planManager.split("\\@").length==2 && planManager.split("\\@")[0].length()>0 && planManager.split("\\@")[1].contains(".")) {
								if(hPlanUids.get(planManager)!=null && ((String)hPlanUids.get(planManager)).contains(planuid)) {
									continue;
								}
								MaintenancePlan plan = MaintenancePlan.get(planuid);
								String sResult = SH.getTranNoLink("gmao", "maintenancereminder", "fr");
								sResult=sResult.replaceAll("#planid#", plan.getUid());
								sResult=sResult.replaceAll("#planname#", SH.capitalize(plan.getName()));
								sResult=sResult.replaceAll("#planfrequency#", SH.getTranNoLink("maintenanceplan.frequency", plan.getFrequency(),"fr"));
								sResult=sResult.replaceAll("#assetid#", plan.getAssetUID());
								sResult=sResult.replaceAll("#assetname#", SH.capitalize(plan.getAssetName()));
								if(nextOperationDate.before(new java.util.Date())) {
									sResult=sResult.replaceAll("#deadline#", "<font style='color: red'>"+SH.formatDate(nextOperationDate)+"</font>");
								}
								else {
									sResult=sResult.replaceAll("#deadline#", SH.formatDate(nextOperationDate));
								}
								if(hMessages.get(planManager)==null) {
									hMessages.put(planManager, "");
								}
								if(hPlanUids.get(planManager)==null) {
									hPlanUids.put(planManager, "");
								}
								hMessages.put(planManager,((String)hMessages.get(planManager))+"<br/>"+sResult);
								hPlanUids.put(planManager,((String)hPlanUids.get(planManager))+";"+plan.getUid());
								if(!getParam(args, "--dryrun", "no").equalsIgnoreCase("no")) {
									System.out.println("Would have sent message to "+planManager+" for MaintenancePlan "+plan.getUid()+":\n"+sResult);
								}
							}
						}
					}
				}
				rs.close();
				ps.close();
				System.out.print("\r100%");
			}
			if(getParam(args, "--dryrun", "no").equalsIgnoreCase("no")) {
				Iterator iMessages = hMessages.keySet().iterator();
				while(iMessages.hasNext()) {
					String planManager = (String)iMessages.next();
					String sHeader = SH.getTranNoLink("gmao", "maintenancereminderheader", "fr");
					String sFooter = SH.getTranNoLink("gmao", "maintenancereminderfooter", "fr");
					String sResult = sHeader+(String)hMessages.get(planManager)+sFooter;
					MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "smtp", sResult, planManager, "MaintenanceReminder", "fr");
					String[] uids = ((String)hPlanUids.get(planManager)).split(";");
					for(int n=0;n<uids.length;n++) {
						if(uids[n].split("\\.").length==2) {
							PreparedStatement ps = conn.prepareStatement("update oc_maintenanceplans set oc_maintenanceplan_lastreminder=? where oc_maintenanceplan_serverid=? and oc_maintenanceplan_objectid=?");
							ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
							ps.setInt(2, Integer.parseInt(uids[n].split("\\.")[0]));
							ps.setInt(3, Integer.parseInt(uids[n].split("\\.")[1]));
							ps.execute();
							ps.close();
							System.out.println("Sent message to "+planManager+" for MaintenancePlan "+uids[n]+":\n"+sResult);
						}
					}
				}
			}

			conn.close();
    	}
    	catch (Exception e) {
			e.printStackTrace();
		}
		System.exit(0);
	}
}

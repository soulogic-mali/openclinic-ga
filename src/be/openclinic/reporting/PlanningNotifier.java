package be.openclinic.reporting;

import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.tools.SendSMS;
import be.mxs.common.util.tools.sendHtmlMail;
import be.openclinic.adt.Planning;
import net.admin.AdminPerson;

public class PlanningNotifier {
	public void sendPlanningMessage(String patientid, String type, String planninguid){
		
	}
	public void sendPlanningReminders(){
		Debug.println("Analyzing planning reminders");
		//Send warnings about upcoming appointments
		if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentEmail",0)==1 || MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentSMS",0)==1 || MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentSMPP",0)==1){
			int warntime=MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentDays",0);
			Debug.println("warntime="+warntime);
			if(warntime>0){
				//First we look for all plannings that should receive a reminder
				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try{
					long day=24*3600*1000;
					String language=MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en");
					PreparedStatement ps = conn.prepareStatement("select * from oc_planning where oc_planning_planneddate>=? and oc_planning_planneddate<=? and oc_planning_remindsent is null");
					ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
					ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()+warntime*day));
					ResultSet rs =ps.executeQuery();
					while(rs.next()){
						Debug.println("Found planning objectid "+rs.getInt("OC_PLANNING_OBJECTID"));
						String patientid=rs.getString("oc_planning_patientuid");
						String planninguid = rs.getInt("oc_PLANNING_SERVERID")+"."+rs.getInt("oc_PLANNING_OBJECTID");
						AdminPerson patient = AdminPerson.getAdminPerson(patientid);
						if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentEmail",0)==1){
							String sendto=patient.getActivePrivate().email;
							Debug.println("Send appointment reminder by e-mail to "+sendto);
							if(MessageNotifier.validateEmailValue(sendto)!=null){
								Debug.println("E-mail address "+sendto+" is valid");
								String sResult = ScreenHelper.getTranNoLink("web", "patientappointmentemailcontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								sResult=sResult.replaceAll("#patientname#", patient.getFullName());
								sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
								MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "simplemail", sResult, sendto, "appointmentreminder", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								Planning.storeRemindSent(planninguid, new java.util.Date());
							}
							else{
								Debug.println("E-mail address "+sendto+" is NOT valid");
							}
						}
						if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentSMS",0)==1){
							String sendto =patient.getActivePrivate().mobile;
							Debug.println("Send appointment reminder by sms to "+sendto);
							if(MessageNotifier.validateSMSValue(sendto)!=null){
								Debug.println("SMS number "+sendto+" is valid");
								String sResult = MedwanQuery.getInstance().getLabel("web", "patientappointmentsmscontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								sResult=sResult.replaceAll("#patientname#", patient.getFullName());
								sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
								MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "sms", sResult, sendto, "appointmentreminder", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								Planning.storeRemindSent(planninguid, new java.util.Date());
							}
						}
						if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeScheduledAppointmentSMPP",0)==1){
							String sendto =patient.getActivePrivate().mobile;
							Debug.println("Send appointment reminder by sms to "+sendto);
							if(MessageNotifier.validateSMSValue(sendto)!=null){
								Debug.println("SMS number "+sendto+" is valid");
								String sResult = MedwanQuery.getInstance().getLabel("web", "patientappointmentsmscontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								sResult=sResult.replaceAll("#patientname#", patient.getFullName());
								sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
								MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "smpp", sResult, sendto, "appointmentreminder", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
								Planning.storeRemindSent(planninguid, new java.util.Date());
							}
						}
					}
					rs.close();
					ps.close();
				}
				catch(Exception e){
					e.printStackTrace();
				}
				finally{
					try{
						conn.close();
					}
					catch(Exception e){
						e.printStackTrace();
					}
				}
			}
		}
	}
}

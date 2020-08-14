package be.openclinic.datacenter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import net.admin.Service;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;

public class ExporterDHIS2Diagnoses extends Exporter {

	public void export(){
		if(!mustExport(getParam())){
			return;
		}
		if(getParam().equalsIgnoreCase("dhis2.1")){
			Debug.println("Exporting dhis2.1");
			Debug.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			//Export a summary of all ICD-10 codes per month, per gender, per age
			//First find first month for which a summary must be provided
			StringBuffer sb = new StringBuffer("<dhis2diags>");
			String firstMonth = MedwanQuery.getInstance().getConfigString("datacenterFirstDHIS2DiagsSummaryMonth","0");
			if(firstMonth.equalsIgnoreCase("0")){
				//Find oldest diagnosis
				Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try {
					PreparedStatement ps = oc_conn.prepareStatement("select count(*) total,min(OC_DIAGNOSIS_DATE) as firstMonth from OC_DIAGNOSES where OC_DIAGNOSIS_CODETYPE='icd10'");
					ResultSet rs = ps.executeQuery();
					if(rs.next() && rs.getInt("total")>0){
						firstMonth=new SimpleDateFormat("yyyyMM").format(rs.getDate("firstMonth"));
					}
					rs.close();
					ps.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				finally {
					try {
						oc_conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			if(!firstMonth.equalsIgnoreCase("0")){
				try {
					boolean bFound=false;
					Date lastDay=new Date(new SimpleDateFormat("yyyyMMdd").parse(new SimpleDateFormat("yyyyMM").format(new Date())+"01").getTime()-1);
					Date firstDay=new SimpleDateFormat("yyyyMMdd").parse(firstMonth+"01");
					if(firstDay.before(ScreenHelper.parseDate("01/01/2005"))){
						firstDay=ScreenHelper.parseDate("01/01/2005");
					}
					int firstYear = Integer.parseInt(new SimpleDateFormat("yyyy").format(firstDay));
					int lastYear = Integer.parseInt(new SimpleDateFormat("yyyy").format(lastDay));
					for(int n=firstYear;n<=lastYear;n++){
						int firstmonth=1;
						if(n==firstYear){
							firstmonth=Integer.parseInt(new SimpleDateFormat("MM").format(firstDay));;
						}
						int lastmonth=12;
						if(n==lastYear){
							lastmonth=Integer.parseInt(new SimpleDateFormat("MM").format(lastDay));;
						}
						for(int i=firstmonth;i<=lastmonth;i++){
							//Find all diagnoses for this month
							Date begin = ScreenHelper.parseDate("01/"+i+"/"+n);
							Date end = ScreenHelper.parseDate(i==12?"01/01/"+(n+1):"01/"+(i+1)+"/"+n);
							Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
							try {
								PreparedStatement ps = oc_conn.prepareStatement("select count(*) total, oc_diagnosis_code,OC_DIAGNOSIS_SERVICEUID,c.gender,floor("+ MedwanQuery.getInstance().datediff("d", "c.dateofbirth", "oc_encounter_enddate")+"/365) age,oc_encounter_type "
										+ " from oc_encounters a, (select distinct oc_diagnosis_encounteruid,oc_diagnosis_code,oc_diagnosis_codetype,OC_DIAGNOSIS_SERVICEUID from oc_diagnoses) b, adminview c "
										+ " where "
										+ " a.oc_encounter_objectid=replace(b.oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"
										+ " oc_encounter_enddate >=? and oc_encounter_enddate <? and "
										+ " oc_diagnosis_codetype='icd10' and "
										+ " a.oc_encounter_patientuid=c.personid"
										+ " group by OC_DIAGNOSIS_SERVICEUID,oc_diagnosis_code,c.gender,floor("+ MedwanQuery.getInstance().datediff("d", "c.dateofbirth", "oc_encounter_enddate")+"/365),oc_encounter_type "
										+ " order by OC_DIAGNOSIS_SERVICEUID,oc_diagnosis_code,oc_encounter_type");
								ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
								ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
								ResultSet rs = ps.executeQuery();
								while(rs.next()){
									bFound=true;
									String serviceuid = MedwanQuery.getInstance().getConfigString("dhis2_otherdepartmentuid","noop");
									Service service = Service.getService(ScreenHelper.checkString(rs.getString("OC_DIAGNOSIS_SERVICEUID")));
									if(service!=null && service.inscode!=null && service.inscode.length()>0){
										serviceuid=service.inscode;
									}
									sb.append("<diagnosis code='"+rs.getString("OC_DIAGNOSIS_CODE")+"' serviceuid='"+serviceuid+"' encountertype='"+ScreenHelper.checkString(rs.getString("oc_encounter_type")).toUpperCase()+"' gender='"+ScreenHelper.checkString(rs.getString("gender")).toUpperCase()+"' age='"+rs.getInt("age")+"' count='"+rs.getInt("total")+"' year='"+n+"' month='"+i+"'/>");
								}
								rs.close();
								ps.close();
							} catch (SQLException e) {
								e.printStackTrace();
							}
							finally {
								try {
									oc_conn.close();
								} catch (SQLException e) {
									e.printStackTrace();
								}
							}
						}
					}
					if(bFound){
						sb.append("</dhis2diags>");
						Debug.println("Exporting dhis2.1 done");
						exportSingleValue(sb.toString(), "dhis2.1");
						MedwanQuery.getInstance().setConfigString("datacenterFirstDHIS2DiagsSummaryMonth", new SimpleDateFormat("yyyyMM").format(new Date(lastDay.getTime()+2)));
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(getParam().equalsIgnoreCase("dhis2.2")){
			Debug.println("Exporting dhis2.2");
			Debug.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			//Export a summary of all ICD-10 codes per month, per gender, per age
			//First find first month for which a summary must be provided
			StringBuffer sb = new StringBuffer("<dhis2diags>");
			String firstMonth = MedwanQuery.getInstance().getConfigString("datacenterFirstDHIS2DeathDiagsSummaryMonth","0");
			if(firstMonth.equalsIgnoreCase("0")){
				//Find oldest diagnosis
				Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try {
					PreparedStatement ps = oc_conn.prepareStatement("select count(*) total,min(OC_DIAGNOSIS_DATE) as firstMonth from OC_DIAGNOSES where OC_DIAGNOSIS_CODETYPE='icd10'");
					ResultSet rs = ps.executeQuery();
					if(rs.next() && rs.getInt("total")>0){
						firstMonth=new SimpleDateFormat("yyyyMM").format(rs.getDate("firstMonth"));
					}
					rs.close();
					ps.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				finally {
					try {
						oc_conn.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
			if(!firstMonth.equalsIgnoreCase("0")){
				try {
					boolean bFound=false;
					Date lastDay=new Date(new SimpleDateFormat("yyyyMMdd").parse(new SimpleDateFormat("yyyyMM").format(new Date())+"01").getTime()-1);
					Date firstDay=new SimpleDateFormat("yyyyMMdd").parse(firstMonth+"01");
					if(firstDay.before(ScreenHelper.parseDate("01/01/2005"))){
						firstDay=ScreenHelper.parseDate("01/01/2005");
					}
					int firstYear = Integer.parseInt(new SimpleDateFormat("yyyy").format(firstDay));
					int lastYear = Integer.parseInt(new SimpleDateFormat("yyyy").format(lastDay));
					for(int n=firstYear;n<=lastYear;n++){
						int firstmonth=1;
						if(n==firstYear){
							firstmonth=Integer.parseInt(new SimpleDateFormat("MM").format(firstDay));;
						}
						int lastmonth=12;
						if(n==lastYear){
							lastmonth=Integer.parseInt(new SimpleDateFormat("MM").format(lastDay));;
						}
						for(int i=firstmonth;i<=lastmonth;i++){
							//Find all diagnoses for this month
							Date begin = ScreenHelper.parseDate("01/"+i+"/"+n);
							Date end = ScreenHelper.parseDate(i==12?"01/01/"+(n+1):"01/"+(i+1)+"/"+n);
							Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
							try {
								PreparedStatement ps = oc_conn.prepareStatement("select count(*) total, oc_diagnosis_code,OC_DIAGNOSIS_SERVICEUID,c.gender,floor("+ MedwanQuery.getInstance().datediff("d", "c.dateofbirth", "oc_encounter_enddate")+"/365) age "
										+ " from oc_encounters a, (select distinct oc_diagnosis_encounteruid,oc_diagnosis_code,oc_diagnosis_codetype,OC_DIAGNOSIS_SERVICEUID from oc_diagnoses) b, adminview c "
										+ " where "
										+ " a.oc_encounter_objectid=replace(b.oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"
										+ " oc_encounter_enddate >=? and oc_encounter_enddate <? and "
										+ " oc_diagnosis_codetype='icd10' and "
										+ " oc_encounter_outcome like 'dead%' and "
										+ " a.oc_encounter_patientuid=c.personid"
										+ " group by OC_DIAGNOSIS_SERVICEUID,oc_diagnosis_code,c.gender,floor("+ MedwanQuery.getInstance().datediff("d", "c.dateofbirth", "oc_encounter_enddate")+"/365) "
										+ " order by OC_DIAGNOSIS_SERVICEUID,oc_diagnosis_code");
								ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
								ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
								ResultSet rs = ps.executeQuery();
								while(rs.next()){
									bFound=true;
									String serviceuid = MedwanQuery.getInstance().getConfigString("dhis2_otherdepartmentuid","oth");
									Service service = Service.getService(ScreenHelper.checkString(rs.getString("OC_DIAGNOSIS_SERVICEUID")));
									if(service!=null && service.inscode!=null && service.inscode.length()>0){
										serviceuid=service.inscode;
									}
									sb.append("<diagnosis code='"+rs.getString("OC_DIAGNOSIS_CODE")+"' serviceuid='"+serviceuid+"' gender='"+ScreenHelper.checkString(rs.getString("gender")).toUpperCase()+"' age='"+rs.getInt("age")+"' count='"+rs.getInt("total")+"' year='"+n+"' month='"+i+"'/>");
								}
								rs.close();
								ps.close();
							} catch (SQLException e) {
								e.printStackTrace();
							}
							finally {
								try {
									oc_conn.close();
								} catch (SQLException e) {
									e.printStackTrace();
								}
							}
						}
					}
					if(bFound){
						sb.append("</dhis2diags>");
						exportSingleValue(sb.toString(), "dhis2.2");
						Debug.println("Exporting dhis2.2 done");
						MedwanQuery.getInstance().setConfigString("datacenterFirstDHIS2DeathDiagsSummaryMonth", new SimpleDateFormat("yyyyMM").format(new Date(lastDay.getTime()+2)));
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
}
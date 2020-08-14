package be.openclinic.datacenter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.system.SH;

public class ExporterMedical extends Exporter {

	public void export(){
		if(!mustExport(getParam())){
			return;
		}
		if(getParam().equalsIgnoreCase("medical.covid")){
			//Export agregate data from Covid-19 clinical record
			//First load agregation parameters
			int nPeriodDays = SH.ci("datacenterCovidPeriodDays", 1);
			//Calculate absolute number over the defined period
			if(nPeriodDays>1) {
				//Calculate moving averages for a window of nPeriodDays days
			}
		}
		else if(getParam().equalsIgnoreCase("medical.1")){
			//Export a summary of all ICD-10 based KPGS codes per month
			//First find first month for which a summary must be provided
			StringBuffer sb = new StringBuffer("<diags>");
			String firstMonth = MedwanQuery.getInstance().getConfigString("datacenterFirstKPGSSummaryMonth","0");
			if(firstMonth.equalsIgnoreCase("0")){
				//Find oldest diagnosis
				Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try {
					PreparedStatement ps = oc_conn.prepareStatement("select count(*) total,min(OC_DIAGNOSIS_DATE) as firstMonth from OC_DIAGNOSES_VIEW");
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
								PreparedStatement ps = oc_conn.prepareStatement("select count(*) total, oc_diagnosis_code from oc_encounters a, oc_diagnoses_view b where a.oc_encounter_objectid=replace(b.oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"+
										" oc_encounter_enddate >=? and oc_encounter_enddate <? and oc_diagnosis_codetype='icd10' group by oc_diagnosis_code order by count(*) desc");
								
								ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
								ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
								ResultSet rs = ps.executeQuery();
								while(rs.next()){
									bFound=true;
									sb.append("<diagnosis code='"+rs.getString("OC_DIAGNOSIS_CODE")+"' count='"+rs.getInt("total")+"' year='"+n+"' month='"+i+"'/>");
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
						sb.append("</diags>");
						exportSingleValue(sb.toString(), "medical.1");
						MedwanQuery.getInstance().setConfigString("datacenterFirstKPGSSummaryMonth", new SimpleDateFormat("yyyyMM").format(new Date(lastDay.getTime()+2)));
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(getParam().equalsIgnoreCase("medical.1.1")){
			//Export a summary of all ICD-10 based KPGS codes per month
			//First find first month for which a summary must be provided
			String admissiontype=MedwanQuery.getInstance().getConfigString("datacenterAdmissionTypes","'admission'");
			StringBuffer sb = new StringBuffer("<diags>");
			String firstMonth = MedwanQuery.getInstance().getConfigString("datacenterFirstAdmissionKPGSSummaryMonth","0");
			if(firstMonth.equalsIgnoreCase("0")){
				//Find oldest diagnosis
				Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try {
					PreparedStatement ps = oc_conn.prepareStatement("select count(*) total,min(OC_DIAGNOSIS_DATE) as firstMonth from OC_DIAGNOSES_VIEW, OC_ENCOUNTERS where replace(OC_DIAGNOSIS_ENCOUNTERUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')=OC_ENCOUNTER_OBJECTID and OC_ENCOUNTER_TYPE in ("+admissiontype+")");
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
								PreparedStatement ps = oc_conn.prepareStatement("select count(*) total, oc_diagnosis_code from oc_encounters a, oc_diagnoses_view b where a.oc_encounter_objectid=replace(b.oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"+
										" oc_encounter_enddate >=? and oc_encounter_enddate <? and oc_diagnosis_codetype='icd10' and oc_encounter_type in ("+admissiontype+") group by oc_diagnosis_code order by count(*) desc");
								ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
								ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
								ResultSet rs = ps.executeQuery();
								while(rs.next()){
									bFound=true;
									sb.append("<diagnosis code='"+rs.getString("OC_DIAGNOSIS_CODE")+"' count='"+rs.getInt("total")+"' year='"+n+"' month='"+i+"'/>");
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
						sb.append("</diags>");
						exportSingleValue(sb.toString(), "medical.1.1");
						MedwanQuery.getInstance().setConfigString("datacenterFirstAdmissionKPGSSummaryMonth", new SimpleDateFormat("yyyyMM").format(new Date(lastDay.getTime()+2)));
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(getParam().equalsIgnoreCase("medical.1.2")){
			//Export a summary of all ICD-10 based KPGS codes per month
			//First find first month for which a summary must be provided
			String visittype=MedwanQuery.getInstance().getConfigString("datacenterVisitTypes","'visit'");
			StringBuffer sb = new StringBuffer("<diags>");
			String firstMonth = MedwanQuery.getInstance().getConfigString("datacenterFirstVisitKPGSSummaryMonth","0");
			if(firstMonth.equalsIgnoreCase("0")){
				//Find oldest diagnosis
				Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
				try {
					PreparedStatement ps = oc_conn.prepareStatement("select count(*) total,min(OC_DIAGNOSIS_DATE) as firstMonth from OC_DIAGNOSES_VIEW, OC_ENCOUNTERS where replace(OC_DIAGNOSIS_ENCOUNTERUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')=OC_ENCOUNTER_OBJECTID and OC_ENCOUNTER_TYPE in("+visittype+")");
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
								PreparedStatement ps = oc_conn.prepareStatement("select count(*) total, oc_diagnosis_code from oc_encounters a, oc_diagnoses_view b where a.oc_encounter_objectid=replace(b.oc_diagnosis_encounteruid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"+
										" oc_encounter_enddate >=? and oc_encounter_enddate <? and oc_diagnosis_codetype='icd10' and oc_encounter_type in ("+visittype+") group by oc_diagnosis_code order by count(*) desc");
								ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
								ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
								ResultSet rs = ps.executeQuery();
								while(rs.next()){
									bFound=true;
									sb.append("<diagnosis code='"+rs.getString("OC_DIAGNOSIS_CODE")+"' count='"+rs.getInt("total")+"' year='"+n+"' month='"+i+"'/>");
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
						sb.append("</diags>");
						exportSingleValue(sb.toString(), "medical.1.2");
						MedwanQuery.getInstance().setConfigString("datacenterFirstVisitKPGSSummaryMonth", new SimpleDateFormat("yyyyMM").format(new Date(lastDay.getTime()+2)));
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		else if(getParam().equalsIgnoreCase("medical.1.3")){
			//Export all registered vaccinations
			if(MedwanQuery.getInstance().getConfigInt("enableMaliVaccinations",0)==1){
				//First find first month for which a summary must be provided
				StringBuffer sb = new StringBuffer("<vaccinations>");
				String firstVaccin = MedwanQuery.getInstance().getConfigString("datacenterFirstVaccinationDate","0");
				if(firstVaccin.equalsIgnoreCase("0")){
					//Find oldest vaccination
					Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
					try {
						PreparedStatement ps = oc_conn.prepareStatement("select count(*) total,min(OC_VACCINATION_UPDATETIME) as firstVaccin from OC_VACCINATIONS where OC_VACCINATION_DATE is not NULL and OC_VACCINATION_DATE<>''");
						ResultSet rs = ps.executeQuery();
						if(rs.next() && rs.getInt("total")>0){
							firstVaccin=new SimpleDateFormat("yyyyMMddHHmmssSSS").format(rs.getDate("firstVaccin"));
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
				if(!firstVaccin.equalsIgnoreCase("0")){
					try {
						boolean bFound=false;
						Date firstDay=new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(firstVaccin);
						if(firstDay.before(ScreenHelper.parseDate("01/01/2005"))){
							firstDay=ScreenHelper.parseDate("01/01/2005");
						}
						Date lastDay=firstDay;
						Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
						try {
							PreparedStatement ps = oc_conn.prepareStatement("select a.*,b.dateofbirth from OC_VACCINATIONS a,adminview b where OC_VACCINATION_PATIENTUID=personid and OC_VACCINATION_UPDATETIME>? and OC_VACCINATION_DATE is not NULL and OC_VACCINATION_DATE<>'' ORDER BY OC_VACCINATION_UPDATETIME ASC");
							ps.setTimestamp(1,new java.sql.Timestamp(firstDay.getTime()));
							ResultSet rs = ps.executeQuery();
							int maxVaccinations=MedwanQuery.getInstance().getConfigInt("maxExportVaccinationsPerBatch",5000);
							int counter=0;
							while(rs.next() && counter<maxVaccinations){
								bFound=true;
								counter++;
								lastDay=rs.getTimestamp("OC_VACCINATION_UPDATETIME");
								java.util.Date birth=rs.getDate("dateofbirth");
								String location=rs.getString("OC_VACCINATION_LOCATION");
								if(location!=null && location.length()>0){
									location=location.substring(0,1);
								}
								sb.append("<vaccination patient='"+rs.getString("OC_VACCINATION_PATIENTUID")+"' type='"+rs.getString("OC_VACCINATION_TYPE")+"' date='"+
								rs.getString("OC_VACCINATION_DATE")+"' updatetime='"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(lastDay)+"' model='mali' location='"+
										location+"' dateofbirth='"+(birth==null?"":new SimpleDateFormat("dd/MM/yyyy").format(birth))+"'/>");
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
						if(bFound){
							sb.append("</vaccinations>");
							exportSingleValue(sb.toString(), "medical.1.3");
							MedwanQuery.getInstance().setConfigString("datacenterFirstVaccinationDate", new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date(lastDay.getTime()+2)));
						}
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
		}
	}
}

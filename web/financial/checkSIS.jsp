<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*,be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	ResultQueryAsegurado insurance = SIS.getAffiliationInformation(Integer.parseInt(activePatient.personid));
	String dob="";
	if(checkString(insurance.getFecNacimiento()).length()>=8){
		dob=insurance.getFecNacimiento().substring(6,8)+"/"+insurance.getFecNacimiento().substring(4,6)+"/"+insurance.getFecNacimiento().substring(0,4);
	}
	//Now check if authorization was obtained
	if(checkString(insurance.getEstado()).equalsIgnoreCase("ACTIVO")){
		Insurance ins = new Insurance();
		ins.setCreateDateTime(new java.util.Date());
		ins.setDefaultInsurance(1);
		ins.setInsuranceCategoryLetter("A");
		ins.setInsurarUid(MedwanQuery.getInstance().getConfigString("SIS","1.29"));
		ins.setPatientUID(activePatient.personid);
		ins.setStart(new java.sql.Timestamp(new java.util.Date().getTime()));
		ins.setType("a");
		ins.setUpdateDateTime(new java.util.Date());
		ins.setUpdateUser(activeUser.userid);
		ins.setVersion(1);
		ins.setInsuranceNr(insurance.getContrato());
		ins.store();
		Acreditacion.store(insurance,Integer.parseInt(activePatient.personid),new java.util.Date(),"SIS");
	}
	
	long day=24*3600*1000;
	boolean bValid = false;
	SIS_Object acreditacion = Acreditacion.getLast(Integer.parseInt(activePatient.personid));
	if(acreditacion!=null){
		SimpleDateFormat deci = new SimpleDateFormat("yyyyMMddHHmmss");
		java.util.Date dValidUntil = new java.util.Date(acreditacion.getValueTimestamp(32).getTime()+day);
		if(dValidUntil.after(new java.util.Date())){
			bValid = true;
		}
		else if(MedwanQuery.getInstance().getConfigInt("enableAccreditationValidityPerEncounter",0)==1){
			Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
			if(activeEncounter!=null){
				bValid = dValidUntil.after(activeEncounter.getBegin());
			}
		}
	}
	
	if(bValid){
		out.print("<input type='hidden' id='authorized' value='1'/>");
	}
%>
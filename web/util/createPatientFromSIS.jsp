<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*,be.openclinic.finance.*"%><%@include file="/includes/validateUser.jsp"%>
<%
	String sSuccess="0";
	String personid = "0";
	String sError="";
	String dni = checkString(request.getParameter("dni"));
	if(dni.length()>0){
		ResultQueryAsegurado insurance = SIS.getAffiliationInformationFromDNI(dni);
		if(insurance.getIdError().trim().equalsIgnoreCase("0")){
			try{
				AdminPerson person = new AdminPerson();
				person.begin = ScreenHelper.formatDate(new java.util.Date());
				person.dateOfBirth = ScreenHelper.formatDate(new SimpleDateFormat("yyyyMMdd").parse(insurance.getFecNacimiento()));
				person.firstname = insurance.getNombres();
				person.setLastnames(insurance.getApePaterno(), insurance.getApeMaterno());
				person.gender = insurance.getGenero().equalsIgnoreCase("0")?"F":"M";
				person.setID("natreg", dni);
				person.personType="1";
				person.language="es";
				person.modifyTime=new java.util.Date();
				person.nativeCountry="pe";
				person.sourceid="1";
				person.updateuserid=activeUser.userid;
				person.comment4=insurance.getIdGrupoPoblacional();
				AdminPrivateContact apc = new AdminPrivateContact();
				apc.begin=ScreenHelper.formatDate(new java.util.Date());
				person.privateContacts.add(apc);
				person.store();
				personid=person.personid;
				
				//Now also add the insurance data
				Insurance ins = new Insurance();
				ins.setCreateDateTime(new java.util.Date());
				ins.setDefaultInsurance(1);
				ins.setInsuranceCategoryLetter(MedwanQuery.getInstance().getConfigString("defaultSISInsuranceCategory","A"));
				ins.setInsuranceNr(insurance.getContrato());
				ins.setInsurarUid(MedwanQuery.getInstance().getConfigString("SIS","1.29"));
				ins.setPatientUID(person.personid);
				try{
					ins.setStart(new java.sql.Timestamp(new SimpleDateFormat("yyyyMMdd").parse(insurance.getFecAfiliacion()).getTime()));
				}
				catch(Exception d){
					ins.setStart(new java.sql.Timestamp(new java.util.Date().getTime()));
				}
				try{
					ins.setStop(insurance.getFecAfiliacion().length()==0?null:new java.sql.Timestamp(new SimpleDateFormat("yyyyMMdd").parse(insurance.getFecCaducidad()).getTime()));
				}
				catch(Exception d){}
				ins.setType(ins.getInsurar().getType());
				ins.setUpdateDateTime(new java.util.Date());
				ins.setUpdateUser(activeUser.userid);
				ins.setVersion(1);
				ins.store();
			}
			catch(Exception e){
				e.printStackTrace();
			}
			
			sSuccess="1";
		}
		else{
			sError=getTranNoLink("accreditationerrors","sis."+insurance.getIdError(),sWebLanguage);
		}
	}
%>
{
	"success":"<%=sSuccess%>",
	"error":"<%=sError%>",
	"personid":"<%=personid %>"
}
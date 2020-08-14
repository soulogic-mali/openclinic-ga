<%@page import="be.mxs.common.util.db.*,net.admin.*,ca.uhn.fhir.rest.client.interceptor.*,ca.uhn.fhir.rest.gclient.*,java.util.*,be.hapi.*"%>
<%@page import="ca.uhn.fhir.context.*,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.Identifier.*,org.hl7.fhir.r4.model.Bundle.*,org.hl7.fhir.instance.model.api.*,ca.uhn.fhir.rest.client.api.*,ca.uhn.fhir.rest.api.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	boolean bUpdateLocal=false,bUpdateMPI=false;
	AdminPerson mpiperson = (AdminPerson)session.getAttribute("f_person");
	mpiperson.personid=activePatient.personid;

	if(request.getParameter("natreg")!=null){
		String s = request.getParameter("natreg");
		if(activePatient.getID("natreg").equalsIgnoreCase(s)){
			mpiperson.setID("natreg",s);
			bUpdateMPI=true;
		}
		else{
			activePatient.setID("natreg",s);
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("lastname")!=null){
		String s = request.getParameter("lastname");
		if(activePatient.lastname.equalsIgnoreCase(s)){
			mpiperson.lastname=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.lastname=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("firstname")!=null){
		String s = request.getParameter("firstname");
		if(activePatient.firstname.equalsIgnoreCase(s)){
			mpiperson.firstname=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.firstname=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("dateofbirth")!=null){
		String s = request.getParameter("dateofbirth");
		if(activePatient.dateOfBirth.equalsIgnoreCase(s)){
			mpiperson.dateOfBirth=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.dateOfBirth=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("gender")!=null){
		String s = request.getParameter("gender");
		if(activePatient.gender.equalsIgnoreCase(s)){
			mpiperson.gender=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.gender=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("language")!=null){
		String s = request.getParameter("language");
		if(activePatient.language.equalsIgnoreCase(s)){
			mpiperson.language=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.language=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("address")!=null){
		String s = request.getParameter("address");
		if(activePatient.getActivePrivate().address.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().address=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().address=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("city")!=null){
		String s = request.getParameter("city");
		if(activePatient.getActivePrivate().city.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().city=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().city=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("zipcode")!=null){
		String s = request.getParameter("zipcode");
		if(activePatient.getActivePrivate().zipcode.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().zipcode=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().zipcode=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("district")!=null){
		String s = request.getParameter("district");
		if(activePatient.getActivePrivate().district.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().district=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().district=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("country")!=null){
		String s = request.getParameter("country");
		if(activePatient.getActivePrivate().country.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().country=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().country=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("telephone")!=null){
		String s = request.getParameter("telephone");
		if(activePatient.getActivePrivate().telephone.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().telephone=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().telephone=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("mobile")!=null){
		String s = request.getParameter("mobile");
		if(activePatient.getActivePrivate().mobile.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().mobile=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().mobile=s;
			bUpdateLocal=true;
		}
	}
	if(request.getParameter("email")!=null){
		String s = request.getParameter("email");
		if(activePatient.getActivePrivate().email.equalsIgnoreCase(s)){
			mpiperson.getActivePrivate().email=s;
			bUpdateMPI=true;
		}
		else{
			activePatient.getActivePrivate().email=s;
			bUpdateLocal=true;
		}
	}
	Iterator<String> iExtends = mpiperson.adminextends.keySet().iterator();
	while(iExtends.hasNext()){
		String key = iExtends.next();
		String value = (String)mpiperson.adminextends.get(key);
		if(activePatient.adminextends.get(key)==null){
			activePatient.adminextends.put(key,value);
			bUpdateLocal=true;
		}
	}
	if(bUpdateLocal){
		activePatient.store();
	}
	if(bUpdateMPI){
		mpiperson.updateMPI();
	}
%>
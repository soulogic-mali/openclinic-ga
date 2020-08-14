<%@page import="be.openclinic.finance.Insurance"%>
<%@page import="be.openclinic.medical.Prescription"%>
<%@page import="be.openclinic.medical.Problem"%>
<%@include file="/includes/helper.jsp"%>
<%!
	Element randomSelect(List list){
		return (Element)list.get(new Double(Math.floor(list.size()*Math.random())).intValue());
	}
	
	java.util.Date makeDate(Element date){
		if(date==null){
			return null;
		}
		int error = 0;
		if(date.attribute("error")!=null){
			error = Integer.parseInt(date.attributeValue("error"))-new Double(Integer.parseInt(date.attributeValue("error"))*2*Math.random()).intValue();
		}
		String s = date.getText();
		long day = 24*3600*1000;
		java.util.Date d = null;
		if(s.startsWith("-") || s.startsWith("+")){
			d = new java.util.Date(new java.util.Date().getTime()+day*Integer.parseInt(s)+day*error);
		}
		else{
			try{
				d = new java.util.Date(new SimpleDateFormat("yyyyMMdd").parse(s).getTime()+error);
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return d;
	}
%>
<head>
    <%=sCSSNORMAL%>
</head>
<%
	//Load training file
	String sDoc = MedwanQuery.getInstance().getConfigString("templateSource") + MedwanQuery.getInstance().getConfigString("trainingFile","train.xml");
	SAXReader reader = new SAXReader(false);
	Document document = reader.read(new URL(sDoc));
	Element root = document.getRootElement();
	//Load patients, lastnames and firstnames
	List patients = root.element("patients").elements("patient");
	List lastnames = root.element("lastnames").elements("lastname");
	List firstnames = root.element("firstnames").elements("firstname");
	Element patient = randomSelect(patients);
	Element lastname = randomSelect(lastnames);
	Element firstname = randomSelect(firstnames);
	AdminPerson person = new AdminPerson();
	person.begin=new SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
	person.dateOfBirth = new SimpleDateFormat("dd/MM/yyyy").format(makeDate(patient.element("dateofbirth")));
	person.firstname = firstname.getText();
	person.gender = patient.elementText("gender");
	person.language = patient.elementText("language");
	person.lastname = lastname.getText();
	person.nativeCountry = patient.elementText("nationality");
	person.sourceid = "1";
	person.updateuserid = "4";
	person.store();
	//Add insurance
	Insurance insurance = new Insurance();
	insurance.setDefaultInsurance(1);
	insurance.setInsuranceCategoryLetter(patient.element("insurance").elementText("category"));
	insurance.setInsurarUid(patient.element("insurance").element("insurer").elementText("uid"));
	insurance.setPatientUID(person.personid);
	insurance.setStart(new java.sql.Timestamp(makeDate(patient.element("insurance").element("start")).getTime()));
	insurance.setUpdateUser("4");
	insurance.setCreateDateTime(new java.util.Date());
	insurance.setUpdateDateTime(new java.util.Date());
	insurance.setType(patient.element("insurance").elementText("type"));
	insurance.store();
	//Add problems
	Iterator problems = patient.elementIterator("problem");
	while(problems.hasNext()){
		Element problem = (Element)problems.next();
		Problem p = new Problem();
		p.setBegin(makeDate(problem.element("begin")));
		p.setCertainty(Integer.parseInt(problem.elementText("certainty")));
		p.setCode(problem.elementText("code"));
		p.setCodeType(problem.elementText("codetype"));
		p.setGravity(Integer.parseInt(problem.elementText("gravity")));
		p.setPatientuid(person.personid);
		p.setUpdateUser("4");	
		p.store();
	}
	//Add drugprescriptions
	Iterator drugprescriptions = patient.elementIterator("drugprescription");
	while(drugprescriptions.hasNext()){
		Element prescription = (Element)drugprescriptions.next();
		Prescription p = new Prescription();
		p.setBegin(makeDate(prescription.element("begin")));
		p.setEnd(makeDate(prescription.element("end")));
		p.setPatientUid(person.personid);
		p.setPrescriberUid("4");
		p.setProductUid(prescription.elementText("productuid"));
		p.setRequiredPackages(Integer.parseInt(prescription.elementText("requiredpackages")));
		p.setSupplyingServiceUid("");
		p.setTimeUnit(prescription.elementText("timeunit"));
		p.setUnitsPerTimeUnit(Double.parseDouble(prescription.elementText("unitspertimeunit")));
		p.setTimeUnitCount(Integer.parseInt(prescription.elementText("timeunitcount")));
		p.setUpdateUser("4");
		p.setUid("-1");
		p.store();
	}
%>
<center>
<img width='150px' src='_img/openclinic_logo.jpg'/>
<h3>
A new patient record has been created for training purposes.<br/>Please take note of the patient data as you will use the same patient record 
throughout the OpenClinic GA exercises.<br/>After that, click on the "Login" button to connect to the OpenClinic GA server.
</h3>
<p/>
<table cellspacing='5' cellpadding='5'>
	<tr class='admin'><td colspan='2'>PATIENT RECORD FOR TRAINING PURPOSES</td></tr>
	<tr>
		<td class='admin'>PERSON ID</td>
		<td class='admin2'><%=person.personid %></td>
	</tr>
	<tr>
		<td class='admin'>LASTNAME</td>
		<td class='admin2'><%=person.lastname.toUpperCase() %></td>
	</tr>	
	<tr>
		<td class='admin'>FIRSTNAME</td>
		<td class='admin2'><%=person.firstname %></td>
	</tr>
	<tr>
		<td class='admin'>DATE OF BIRTH</td>
		<td class='admin2'><%=person.dateOfBirth %></td>
	</tr>
	<tr>
		<td class='admin'>GENDER</td>
		<td class='admin2'><%=person.gender.toUpperCase() %></td>
	</tr>
	<tr>
		<td colspan='2'><center><input type='button' class='button' name='login' value='Login' onclick='window.location.href="login.jsp";'/></center></td>
	</tr>
</table>
</center>



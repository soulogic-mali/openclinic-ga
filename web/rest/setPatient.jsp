<%@page import="java.text.*,java.util.*,org.dom4j.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*"%><%
	String key = ScreenHelper.checkString(request.getParameter("key"));
	String natreg = ScreenHelper.checkString(request.getParameter("natreg"));
	String lastname = ScreenHelper.checkString(request.getParameter("lastname"));
	String firstname = ScreenHelper.checkString(request.getParameter("firstname"));
	String dateofbirth = ScreenHelper.checkString(request.getParameter("dateofbirth"));
	String gender = ScreenHelper.checkString(request.getParameter("gender"));
	String language = ScreenHelper.checkString(request.getParameter("language"));
	String address = ScreenHelper.checkString(request.getParameter("address"));
	String zipcode = ScreenHelper.checkString(request.getParameter("zipcode"));
	String city = ScreenHelper.checkString(request.getParameter("city"));
	String country = ScreenHelper.checkString(request.getParameter("country"));
	
	Vector<String> errors = new Vector<String>();
	Vector<String> warnings = new Vector<String>();
	if(key.length()==0 || MedwanQuery.getInstance().getConfigInt("restKey."+key,0)==0){
		errors.add("InvalidKey");
	}
	if(natreg.length()==0){
		errors.add("MissingNatReg");
	}
	try{
		if(dateofbirth.length()>0){
			dateofbirth=new SimpleDateFormat("dd/MM/yyyy").format(new SimpleDateFormat("yyyyMMdd").parse(dateofbirth));
		}
	}
	catch(Exception e){
		errors.add("WrongDateOfBirthFormat");
	}
	if(gender.length()>0 && !"MF".contains(gender.toUpperCase())){
		errors.add("WrongGenderFormat");
	}
	String personid = AdminPerson.getPersonIdByNatReg(natreg);
	if(personid!=null){
		warnings.add("PatientRecordExists");
	}
	if(errors.size()>0){
		org.dom4j.Document document = DocumentHelper.createDocument();
		for(int n=0;n<errors.size();n++){
			document.addElement("error").setText(errors.elementAt(n));
		}
		out.println(document.asXML());
	}
	else{
		AdminPerson person = new AdminPerson();
		if(personid!=null){
			person=AdminPerson.getAdminPerson(personid);
		}
		person.setID("natreg",natreg);
		person.lastname=lastname;
		person.firstname=firstname;
		if(dateofbirth.length()>0){
			person.dateOfBirth=dateofbirth;
		}
		person.gender=gender;
		person.sourceid="4";
		person.updateuserid="4";
		person.language=language;
		AdminPrivateContact apc = person.getActivePrivate();
		apc.address=address;
		apc.zipcode=zipcode;
		apc.city=city;
		apc.country=country;
		person.store();
		personid=person.personid;
		org.dom4j.Document document = DocumentHelper.createDocument();
		Element root = document.addElement("patient");
		root.addAttribute("personid", personid);
		for(int n=0;n<warnings.size();n++){
			root.addElement("warning").setText(warnings.elementAt(n));
		}
		out.println(be.openclinic.api.API.prettyPrintXml(document.asXML()));
	}
%>
<%@page import="org.dom4j.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*"%><%
	String foundPersonId="-1";
	String key = ScreenHelper.checkString(request.getParameter("key"));
	if(key.length()>0 && MedwanQuery.getInstance().getConfigInt("restKey."+key,0)!=0){
		String natreg = ScreenHelper.checkString(request.getParameter("natreg"));
		String personid = ScreenHelper.checkString(request.getParameter("personid"));
		if(personid.length()>0){
			AdminPerson person = AdminPerson.getAdminPerson(personid);
			if(person.isNotEmpty() && (natreg.length()==0 || natreg.equalsIgnoreCase(person.getID("natreg")))){
				foundPersonId=personid;
			}
		}
		else if(foundPersonId.equalsIgnoreCase("-1") && natreg.length()>0){
			personid = AdminPerson.getPersonIdByNatReg(natreg);
			if(personid!=null){
				foundPersonId=personid;
			}
		}
		if(!foundPersonId.equalsIgnoreCase("-1")){
			org.dom4j.Document document = DocumentHelper.createDocument();
			document.addElement("patient").addAttribute("personid", foundPersonId);
			out.println(document.asXML());
		}
		else{
			org.dom4j.Document document = DocumentHelper.createDocument();
			document.addElement("error").setText("PatientDoesNotExist");
			out.println(document.asXML());
		}
	}
	else{
		org.dom4j.Document document = DocumentHelper.createDocument();
		document.addElement("error").setText("InvalidKey");
		out.println(document.asXML());
	}
%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/patient/patienteditHelper.jsp"%>
<%
	String personid = SH.p(request, "personid");
	
	AdminPerson person = new AdminPerson();
	if(personid.length()>0){
		person=AdminPerson.getAdminPerson(personid);
	}
	person.firstname=SH.p(request,"firstname");
	person.lastname=SH.p(request,"lastname");
	person.dateOfBirth=SH.p(request,"dateofbirth");
	person.gender=SH.p(request,"gender");
	if(person.privateContacts.size()==0){
		person.privateContacts.add(new AdminPrivateContact());
	}
	person.getActivePrivate().telephone=SH.p(request,"phone");
	person.getActivePrivate().city=SH.p(request,"phonefather");
	person.getActivePrivate().cell=SH.p(request,"phonemother");
	person.sourceid="4";
	person.updateuserid=activeUser.userid;
	person.store();
	
    SAXReader xmlReader = new SAXReader();
    String sDefaultPageXML = MedwanQuery.getInstance().getConfigString("templateSource")+"defaultPages.xml";
    Document document;

    Hashtable hDefaultPages = new Hashtable();
    boolean bXMLDocumentError = false;
    try{
        document = xmlReader.read(new URL(sDefaultPageXML));
        if(document!=null){
            Element root = document.getRootElement();
            if(root!=null){
                Element ePage;
                Iterator elements = root.elementIterator("defaultPage");
                String sType, sPageLink;
                while (elements.hasNext()){
                    ePage = (Element) elements.next();
                    sType = checkString(ePage.attributeValue("type")).toLowerCase();
                    sPageLink = checkString(ePage.elementText("page"));
                    hDefaultPages.put(sType,sPageLink);
                }
            }
        }
    }
    catch(Exception e){
        Debug.println("XML-Document Exception in patientEditCompactSave.jsp");
        bXMLDocumentError = true;
    }
    String sPage = activeUser.getParameter("DefaultPage");
    String sType = checkString((String) hDefaultPages.get(sPage.toLowerCase()));
    if(sType.length() > 0){
        if(sPage.equals("administration")){
            sPage = "patientdata.do?ts="+getTs()+"&personid=";
        }
        else{
            sPage = sType+"&ts="+getTs()+"&PersonID=";
        }
    }


%>
<script>
	window.location.href='<%=sCONTEXTPATH+"/"+sPage+person.personid%>';
</script>
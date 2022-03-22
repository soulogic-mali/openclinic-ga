<%@page import="ocdhis2.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'><td colspan="3"><%=getTran(request,"web","dhis2patientrecords",sWebLanguage) %></td></tr>
<%
	try{
		long day = 24*3600*1000;
		long month=32*day;
		String dataset = checkString(request.getParameter("dataset"));
		String dataelement = checkString(request.getParameter("dataelement"));
		String attributeoption = checkString(request.getParameter("attributeoption"));
		String option = checkString(request.getParameter("option"));
		String period = checkString(request.getParameter("period"));
		DHIS2Exporter exporter = new DHIS2Exporter(dataset);
		String format = checkString(request.getParameter("format"));
		if(ScreenHelper.parseDate(request.getParameter("begin"))!=null && ScreenHelper.parseDate(request.getParameter("end"))!=null){
			exporter.setBegin(ScreenHelper.parseDate(request.getParameter("begin")));
			exporter.setEnd(ScreenHelper.parseDate(request.getParameter("end")));
		}
		else{
			exporter.setBegin(new SimpleDateFormat("yyyyMMdd").parse(request.getParameter("period")+"01"));
			exporter.setEnd(new SimpleDateFormat("yyyyMMdd").parse(new SimpleDateFormat("yyyyMM").format(new java.util.Date(exporter.getBegin().getTime()+month))+"01"));
		}
		exporter.setDhis2document(MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common_xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml"));
		exporter.setLanguage(sWebLanguage);
		String[] records=exporter.showRecords(dataelement, option,attributeoption).split(";");
		for(int n=0;n<records.length;n++){
			String personid=records[n];
			Debug.println(records[n]);
			AdminPerson p = AdminPerson.getAdminPerson(personid);
			out.println("<tr><td class='admin'>"+(n+1)+". <a href='"+sCONTEXTPATH+"/main.do?Page=curative/index.jsp&PersonID="+personid+"'>"+personid+"</a></td><td class='admin2'/>"+(p!=null?p.getFullName():"?")+"</td><td class='admin2'/>"+(p!=null?p.dateOfBirth:"?")+"</td></tr>");
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
</table>
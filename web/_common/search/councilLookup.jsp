<%@page import="java.io.*,
                be.mxs.common.util.io.*,
                org.apache.commons.httpclient.*,
                org.apache.commons.httpclient.methods.*,
                be.openclinic.finance.*,
                be.openclinic.adt.*"%>
<%@ include file="/includes/validateUser.jsp" %>

<table width='100%' class="list" cellspacing="1" cellpadding="0">
<%
	HttpClient client = new HttpClient();
	String language = request.getParameter("language");
	String lookupUrl = getTran(request,"professional.council.url",request.getParameter("council"),language);
	
	PostMethod method = new PostMethod(lookupUrl);
	method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
	
	NameValuePair nvp1 = new NameValuePair("regnr",request.getParameter("regnr")),
	              nvp2 = new NameValuePair("key",MedwanQuery.getInstance().getConfigString("councilLookupKey"));
	
	method.setQueryString(new NameValuePair[]{nvp1,nvp2});
	int userid = 0;
	if(request.getParameter("userid")!=null){
		userid = Integer.parseInt(request.getParameter("userid"));
	}
	
	try{
		int statusCode = client.executeMethod(method);
		if(statusCode==200){
			String xml = method.getResponseBodyAsString();
			org.dom4j.Document document = null;
			Element root = null;
			
			BufferedReader r = new BufferedReader(new StringReader(xml));
			SAXReader reader = new SAXReader(false);
			document = reader.read(r);
			root = document.getRootElement();
			if(root.getName().equalsIgnoreCase("registration")){
				out.print("<tr class='admin'>"+
			               "<td colspan='2'>"+getTran(request,"Web.UserProfile","organisationId",language)+"</td>"+
				           "<td colspan='2'>"+root.attributeValue("id")+"</td>"+
			              "</tr>");
				
				Element element = root.element("status");
				if(element!=null){
					User user = User.get(userid);
					if(user!=null && !user.getParameter("registrationstatus").equalsIgnoreCase(element.attributeValue("id"))){
						user.updateParameter(new Parameter("registrationstatus",element.attributeValue("id")));
						user.updateParameter(new Parameter("registrationstatusdate",ScreenHelper.stdDateFormat.format(new java.util.Date())));						
					}
					
					if(user !=null){
						user.updateParameter(new Parameter("registrationstatusupdatetime",ScreenHelper.stdDateFormat.format(new java.util.Date())));
						user = User.get(userid);
						
						out.print("<script>window.opener.document.getElementById('registrationstatus').innerHTML='"+(user.getParameter("registrationstatus").equalsIgnoreCase("0")?"<img src=\""+sCONTEXTPATH+"/_img/themes/default/checked.png\"/>":"<img src=\""+sCONTEXTPATH+"/_img/icons/icon_error.jpg\"/>")+" <b>"+getTranNoLink("lookup","status."+user.getParameter("registrationstatus"),language)+" ("+user.getParameter("registrationstatusupdatetime")+")</b>';</script>");
					}
					
					if(element.attributeValue("id").equalsIgnoreCase("0")||element.attributeValue("id").equalsIgnoreCase("-2")){
						out.print("<tr><td class='admin'>"+getTran(request,"lookup","status",language)+"</td><td bgcolor='"+(element.attributeValue("id").equalsIgnoreCase("-2")?"red":"lightgreen")+"'>"+getTran(request,"lookup","status."+element.attributeValue("id"),language)+"</td>");
						out.print("<td class='admin'>"+getTran(request,"web","nationality",language)+"</td><td class='admin2'>"+root.elementText("nationality").toUpperCase().replaceAll("COUNTRY.","")+"</td></tr>");
						out.print("<tr><td class='admin'>"+getTran(request,"web","lastname",language)+(root.elementText("lastname").equalsIgnoreCase(activePatient.lastname)?"":" <img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'>")+"</td><td "+(root.elementText("lastname").equalsIgnoreCase(activePatient.lastname)?"bgcolor='lightgreen'":"bgcolor='red'")+">"+root.elementText("lastname").toUpperCase()+"</td>");
						out.print("<td class='admin'>"+getTran(request,"web","firstname",language)+(root.elementText("firstname").equalsIgnoreCase(activePatient.firstname)?"":" <img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'>")+"</td><td "+(root.elementText("firstname").equalsIgnoreCase(activePatient.firstname)?"bgcolor='lightgreen'":"bgcolor='red'")+">"+root.elementText("firstname")+"</td></tr>");
						out.print("<tr><td class='admin'>"+getTran(request,"web","gender",language)+"</td><td class='admin2'>"+root.elementText("gender").toUpperCase()+"</td>");
						out.print("<td class='admin'>"+getTran(request,"web","dateofbirth",language)+"</td><td class='admin2'>"+root.elementText("dateofbirth")+"</td></tr>");
						if(element.attributeValue("id").equalsIgnoreCase("0")){
							element = root.element("contact");
							if(element!=null){
								out.print("<tr class='admin'><td colspan='4'>"+getTran(request,"web","contact",language).toUpperCase()+"</td></tr>");
								out.print("<tr><td class='admin'>"+getTran(request,"web","address",language)+"</td><td class='admin2'>"+element.elementText("address")+"</td>");
								out.print("<td class='admin'>"+getTran(request,"web","pobox",language)+"</td><td class='admin2'>"+element.elementText("pobox")+"</td></tr>");
								out.print("<tr><td class='admin'>"+getTran(request,"web","district",language)+"</td><td class='admin2'>"+element.elementText("district")+"</td>");
								out.print("<td class='admin'>"+getTran(request,"web","province",language)+"</td><td class='admin2'>"+element.elementText("province")+"</td></tr>");
								out.print("<tr><td class='admin'>"+getTran(request,"web","country",language)+"</td><td class='admin2'>"+element.elementText("country")+"</td>");
								out.print("<td class='admin'>"+getTran(request,"web","email",language)+"</td><td class='admin2'>"+element.elementText("email")+"</td></tr>");
								out.print("<tr><td class='admin'>"+getTran(request,"web","phone",language)+"</td><td class='admin2'>"+element.elementText("phone")+"</td>");
								out.print("<td class='admin'>"+getTran(request,"web","cellphone",language)+"</td><td class='admin2'>"+element.elementText("cellphone")+"</td></tr>");
							}
							Iterator elements = root.elementIterator("work");
							if(elements.hasNext()){
								out.print("<tr class='admin'><td colspan='4'>"+getTran(request,"lookup","work",language).toUpperCase()+"</td></tr>");
							}
							
							while(elements.hasNext()){
								element = (Element)elements.next();
								out.print("<tr class='admin'><td colspan='2'>"+getTran(request,"web","period",language)+"</td><td colspan='2'>"+element.attributeValue("start")+" - "+checkString(element.attributeValue("end"))+"</td></tr>");
								out.print("<tr><td class='admin'> "+getTran(request,"web","specialty",language)+"</td><td class='admin2'>"+element.elementText("specialty")+"</td>");
								out.print("<td class='admin'>"+getTran(request,"web","function",language)+"</td><td class='admin2'>"+element.elementText("function")+"</td></tr>");
								out.print("<tr><td class='admin'> "+getTran(request,"web","healthfacility",language)+"</td><td class='admin2'>"+element.elementText("healthfacility").toUpperCase()+"</td>");
								out.print("<td class='admin'> "+getTran(request,"web","category",language)+"</td><td class='admin2'>"+element.elementText("category")+"</td></tr>");
							}
							
							elements = root.elementIterator("training");
							if(elements.hasNext()){
								out.print("<tr class='admin'>"+
							               "<td colspan='4'>"+getTran(request,"lookup","training",language).toUpperCase()+"</td>"+
								          "</tr>");
							}
							while(elements.hasNext()){
								element = (Element)elements.next();
								out.print("<tr class='admin'>"+
								           "<td colspan='2'> "+getTran(request,"web","period",language)+"</td>"+
								           "<td colspan='2'>"+element.attributeValue("start")+" - "+checkString(element.attributeValue("end"))+"</td>"+
								          "</tr>");
								out.print("<tr>"+
								           "<td class='admin'> "+getTran(request,"lookup","center",language)+"</td>"+
								           "<td class='admin2'>"+element.elementText("center")+"</td>"+
								           "<td class='admin'>"+getTran(request,"web","address",language)+"</td>"+
								           "<td class='admin2'>"+element.elementText("address")+"</td>"+
								          "</tr>");
								out.print("<tr>"+
								           "<td class='admin'> "+getTran(request,"web","country",language)+"</td>"+
								           "<td class='admin2' colspan='3'>"+element.elementText("country").toUpperCase().replaceAll("COUNTRY.","")+"</td>"+
								          "</tr>");
								out.print("<tr>"+
								           "<td class='admin'> "+getTran(request,"web","diploma",language)+"</td>"+
								           "<td class='admin2'>"+element.elementText("diploma")+"</td>"+
								           "<td class='admin'>"+getTran(request,"web","diplomadate",language)+"</td>"+
								           "<td class='admin2'>"+element.elementText("diplomadate")+"</td>"+
								          "</tr>");
							}
							
							elements = root.elementIterator("cpd");
							if(elements.hasNext()){
								out.print("<tr class='admin'>"+
							               "<td colspan='4'>"+getTran(request,"lookup","cpd",language).toUpperCase()+"</td>"+
								          "</tr>");
							}
							
							while(elements.hasNext()){
								element = (Element)elements.next();
								out.print("<tr>"+
								           "<td class='admin'>"+getTran(request,"web","year.and.category",language)+"</td>"+
								           "<td class='admin2'>"+element.attributeValue("year")+" / "+element.attributeValue("category")+"</td>"+
								           "<td class='admin'>"+getTran(request,"web","credits",language)+"</td>"+
								           "<td class='admin2'>"+element.attributeValue("credits")+"</td>"+
								          "</tr>");
							}
						}
					}
					else{
						out.print("<tr>"+
					               "<td class='admin'>"+getTran(request,"lookup","status",language)+"</td>"+
						           "<td colspan='3' bgcolor='red'>"+getTran(request,"lookup","status."+element.attributeValue("id"),language)+"</td>"+
					              "</tr>");
					}
				}
				else{
					out.print("<tr><td>"+root.getText()+"</td></tr>");
				}
			}
			else{
				out.print("<tr><td>"+xml+"</td></tr>");
			}
		}
		else{
			out.print("<tr><td>"+method.getStatusLine()+"</td></tr>");
		}
	}
	catch(Exception e){
		out.print("<tr><td>"+e.getMessage()+"</td></tr>");
	}
%>
</table>
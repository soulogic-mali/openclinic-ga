<%@page import="be.openclinic.reporting.*,java.io.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sReportUid = checkString(request.getParameter("selectedreport"));
%>
<form name='reportForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web.manage","managereports",sWebLanguage) %></td></tr>
		<tr class='admin'>
			<td width='10%' nowrap><%=getTran(request,"web","report",sWebLanguage) %></td>
			<td>
				<select class='text' name='selectedreport' id='selectedreport' onchange='reportForm.submit();'>
					<option value=''></option>
					<%
						Vector reports = be.openclinic.reporting.Report.getAll();
						for(int n=0;n<reports.size();n++){
							Report r = (Report)reports.elementAt(n);
							String groupRights=MedwanQuery.getInstance().getConfigString("reportGroupAccessRights."+r.getGroup(),"");
							if(groupRights.length()<2 || groupRights.indexOf(";"+activeUser.getParameter("userprofileid")+";")>-1){
								out.println("<option value='"+r.getUid()+"' "+(sReportUid.equalsIgnoreCase(r.getUid())?"selected":"")+">"+r.getName()+"</option>");
							}
						}
					%>
				</select>
				<input type='radio' name='reportformat' value='pdf' checked/>PDF
				<input type='radio' name='reportformat' value='xls'/>XLS
				<input type='radio' name='reportformat' value='html'/>HTML
				<input type='radio' name='reportformat' value='rtf'/>RTF&nbsp;&nbsp;&nbsp;
				<input type='button' name='executebutton' value='<%=getTran(null,"web","execute",sWebLanguage) %>' onclick='executeReport();'/>
			</td>
				
		</tr>
		<%
			if(sReportUid.length()>0){
				Report report = Report.get(sReportUid);
				if(checkString(report.getInputxml()).length()>0){
				    SAXReader reader = new SAXReader(false);
					BufferedReader br = new BufferedReader(new StringReader(checkString(report.getInputxml())));
					Document document = reader.read(br);
					Element root = document.getRootElement();
					Iterator iFields = root.elementIterator();
					while(iFields.hasNext()){
						Element field = (Element)iFields.next();
						if(field.getName().equalsIgnoreCase("field")){
							out.println("<tr><td class='admin'>"+field.elementText("name")+"&nbsp;</td>");
							if(field.elementText("type").equalsIgnoreCase("text")){
								out.println("<td class='admin2'><input class='text' type='text' name='fieldname_"+field.elementText("name")+"' size='40' value='"+(checkString(field.elementText("modifier")).equalsIgnoreCase("wildcard")?"%":"")+"'/></td>");
							}
							else if(field.elementText("type").equalsIgnoreCase("date")){
								out.println("<td class='admin2'>"+ScreenHelper.writeDateField("fieldname_"+field.elementText("name"), "reportForm", "", true, true, sWebLanguage, sCONTEXTPATH)+"</td>");
							}
							else if(field.elementText("type").equalsIgnoreCase("select")){
								out.println("<td class='admin2'><select class='text' name='fieldname_"+field.elementText("name")+"'>"+ScreenHelper.writeSelect(request,field.elementText("modifier"), "", sWebLanguage)+"</select></td>");
							}
							else if(field.elementText("type").equalsIgnoreCase("service")){
				            	String sServiceUid = checkString((String)session.getAttribute("activeservice"));
				            	if(sServiceUid.length()==0){   	
				            		sServiceUid=activeUser.getParameter("defaultserviceid");
				            	}
			                    out.println("<td class='admin2'><input type='hidden' name='fieldname_"+field.elementText("name")+"' value='"+sServiceUid+"'>");
			                    out.println("<input class='text' type='text' name='servicename_"+field.elementText("name")+"' id='servicename_"+field.elementText("name")+"' readonly size='40' value='"+getTranNoLink("service",sServiceUid,sWebLanguage)+"'>&nbsp;");
			                    out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"' onclick='searchService(\"fieldname_"+field.elementText("name")+"\",\"servicename_"+field.elementText("name")+"\");'>&nbsp;");
			                    out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick='fieldname_"+field.elementText("name")+".value=\"\";servicename_"+field.elementText("name")+".value=\"\";'></td>");
							}
							else if(field.elementText("type").equalsIgnoreCase("nomenclature")){
			                    out.println("<td class='admin2'><input type='hidden' name='fieldname_"+field.elementText("name")+"' id='fieldname_"+field.elementText("name")+"' value=''>");
			                    out.println("<input class='text' type='text' name='nomenclaturename_"+field.elementText("name")+"' id='nomenclaturename_"+field.elementText("name")+"' readonly size='40' value=''>&nbsp;");
			                    out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"' onclick='searchNomenclature(\"fieldname_"+field.elementText("name")+"\",\"nomenclaturename_"+field.elementText("name")+"\");'>&nbsp;");
			                    out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick='fieldname_"+field.elementText("name")+".value=\"\";nomenclaturename_"+field.elementText("name")+".value=\"\";'></td>");
							}
							else if(field.elementText("type").equalsIgnoreCase("patient")){
			                    out.println("<td class='admin2'><input type='hidden' name='fieldname_"+field.elementText("name")+"'>");
			                    out.println("<input class='text' type='text' name='patientname_"+field.elementText("name")+"' id='patientname_"+field.elementText("name")+"' readonly size='40'>&nbsp;");
			                    out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"' onclick='searchPatient(\"fieldname_"+field.elementText("name")+"\",\"patientname_"+field.elementText("name")+"\");'>&nbsp;");
			                    out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick='fieldname_"+field.elementText("name")+".value=\"\";patientname_"+field.elementText("name")+".value=\"\";'></td>");
							}
							out.println("</tr>");
						}
					}
				}				
			}
		%>
	</table>
</form>

<script>
	function searchNomenclature(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchNomenclature.jsp&ts=<%=getTs()%>&FindType=asset&FindCode="+document.getElementById(CategoryUidField).value+"&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	    document.getElementById(CategoryNameField).focus();
	}
	function searchService(serviceUidField,serviceNameField){
	    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementsByName(serviceNameField)[0].focus();
	}
	function searchPatient(patientUidField,patientNameField){
	    openPopup("_common/search/searchPatient.jsp&ts=<%=getTs()%>&ReturnPersonID="+patientUidField+"&ReturnName="+patientNameField);
	    document.getElementsByName(patientNameField)[0].focus();
	}
	function executeReport(){
		var parameters="personid=<%=activePatient==null?"":activePatient.personid%>&reportuid="+document.getElementById("selectedreport").value+"&format="+reportForm.reportformat.value+"&language=<%=sWebLanguage%>";
		var elements = document.all;
		for(n=0;n<elements.length;n++){
			if(elements[n].name && elements[n].name.indexOf("fieldname_")>-1){
				parameters+="&"+elements[n].name+"="+elements[n].value.replace("%","%25");
			}
		}
	    window.open("<c:url value='statistics/printJasperReport.jsp'/>?ts=<%=getTs()%>&"+parameters,"OpenClinic_Report","toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600,menubar=no");
	}
</script>
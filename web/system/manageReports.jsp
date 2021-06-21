<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>
<%@page import="org.dom4j.tree.*, 
	be.openclinic.reporting.*,java.io.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%!
Element getElement(Element element, String elementname, String attributename,String attributevalue){
	Iterator elements = element.elementIterator(elementname);
	while(elements.hasNext()){
		Element e = (Element)elements.next();
		if(e.attributeValue(attributename)!=null && ((attributevalue==null) || (e.attributeValue(attributename).equalsIgnoreCase(attributevalue)))){
			return e;
		}
	}
	return null;
}

%>
<%=sJSPROTOTYPE %>

<%
	String sAction = checkString(request.getParameter("action"));
	String sReportName = checkString(request.getParameter("reportname"));
	String sReportInputXml = checkString(request.getParameter("reportinputxml"));
	String sReportGroup = checkString(request.getParameter("reportgroup"));
	String sReportMakeExcelCorrection = checkString(request.getParameter("reportmakeexcelcorrection"));
	String sReportProfiles = ";";
	String sReportUid = checkString(request.getParameter("selectedreport"));
	String sReportXml="";

	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (!isMultipart) {
		Debug.println("NOT MULTIPART");
	}
	else{
	    FileItemFactory factory = new DiskFileItemFactory();
	    ServletFileUpload upload = new ServletFileUpload(factory);
	    List items = null;
	    try {
	        items = upload.parseRequest((HttpServletRequest)request);
        } catch (FileUploadException e) {
             e.printStackTrace();
        }
	    Iterator itr = items.iterator();
	    while (itr.hasNext()) {
	        FileItem item = (FileItem) itr.next();
	        if (item.isFormField()) {
	        	if(item.getFieldName().equalsIgnoreCase("action")){
	        		sAction = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("reportname")){
	        		sReportName = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("reportinputxml")){
	        		sReportInputXml = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("reportgroup")){
	        		sReportGroup = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("reportprofiles")){
	        		sReportProfiles += item.getString()+";";
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("selectedreport")){
	        		sReportUid = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("reportmakeexcelcorrection")){
	        		sReportMakeExcelCorrection = item.getString();
	        	}
	        } else {
	        	try {
	        		if(item.getFieldName().equalsIgnoreCase("reportfile")){
	        			sReportXml=item.getString();
	        		}
	            } catch (Exception e) {
	                 e.printStackTrace();
	            }
	      	}
		}
	 }	

	
	Report report = new Report();
	report.setUid(sReportUid);
	if(sAction.equalsIgnoreCase("edit") && sReportUid.length()>0){
		report= Report.get(sReportUid);
	}
	else if(sAction.equalsIgnoreCase("delete")){
		Report.delete(sReportUid);
	}
	else if(sAction.equalsIgnoreCase("save")){
		if(sReportUid.length()>0){
			report=Report.get(sReportUid);
		}
		report.setName(sReportName);
		report.setGroup(checkString(sReportGroup));
		MedwanQuery.getInstance().setConfigString("reportGroupAccessRights."+sReportGroup,sReportProfiles);
		if(sReportInputXml.length()>0){
			sReportInputXml="<fields>"+sReportInputXml+"</fields>";
		}
		report.setInputxml(sReportInputXml);
		if(sReportXml.length()>0){
			report.setReportxml(sReportXml);
		}
		if(checkString(report.getReportxml()).length()>0){
		    SAXReader reader = new SAXReader(false);
			BufferedReader br = new BufferedReader(new StringReader(report.getReportxml()));
			Document document = reader.read(br);
			Element root = document.getRootElement();
			if(sReportMakeExcelCorrection.equalsIgnoreCase("1")){
				Element e = getElement(root, "property", "name","net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.1");
				if(e==null){
					DefaultElement newElement = new DefaultElement("property",root.getNamespace());
					newElement.addAttribute("name", "net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.1");
					newElement.addAttribute("value", "columnHeader");
				    List content = document.getRootElement().content();
				    if (content != null ) {
				        content.add(0, newElement);
				    }
					
				    newElement = new DefaultElement("property",root.getNamespace());
					newElement.addAttribute("name", "net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.2");
					newElement.addAttribute("value", "pageHeader");
				    content = document.getRootElement().content();
				    if (content != null ) {
				        content.add(0, newElement);
				    }
				}
			}
			else {
				Element e = getElement(root, "property", "name","net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.1");
				if(e!=null){
					root.remove(e);
				}
				e = getElement(root, "property", "name","net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.2");
				if(e!=null){
					root.remove(e);
				}
			}
			report.setReportxml(document.asXML());
		}
		report.store();
		sReportUid=report.getUid();
	}
%>
<form name='transactionForm' method='post' enctype='multipart/form-data'>
	<input type='hidden' name='action' id='action' value=''/>
	<input type='hidden' name='reportinputxml' id='reportinputxml' value='<%=checkString(report.getInputxml()).replaceAll("<fields>","").replaceAll("</fields>","")%>'/>
	<table width='100%'>
		<tr class='admin'><td colspan='4'><%=getTran(request,"web.manage","managereports",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin' width='10%' nowrap><%=getTran(request,"web","report",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<select class='text' name='selectedreport' id='selectedreport' onchange='document.getElementById("action").value="edit";transactionForm.submit();'>
					<option value=''></option>
					<%
						Vector reports = be.openclinic.reporting.Report.getAll();
						for(int n=0;n<reports.size();n++){
							Report r = (Report)reports.elementAt(n);
							out.println("<option value='"+r.getUid()+"' "+(!sAction.equalsIgnoreCase("new") && sReportUid.equalsIgnoreCase(r.getUid())?"selected":"")+">"+r.getName()+"</option>");
						}
					%>
				</select>
				<input type='button' name='newbutton' value='<%=getTran(null,"web","new",sWebLanguage) %>' onclick='document.getElementById("action").value="new";transactionForm.submit();'/>
				<input type='button' name='savebutton' value='<%=getTran(null,"web","save",sWebLanguage) %>' onclick='document.getElementById("action").value="save";transactionForm.submit();'/>
				<input type='button' name='deletebutton' value='<%=getTran(null,"web","delete",sWebLanguage) %>' onclick='document.getElementById("action").value="delete";transactionForm.submit();'/>
			</td>
		</tr>
		<%
			if(sAction.equals("new") || sAction.equalsIgnoreCase("edit") || sAction.equalsIgnoreCase("save")){
		%>
		<tr>
			<td class='admin'><%=getTran(request,"web","reportname",sWebLanguage) %></td>
			<td class='admin2' colspan='2'><input type='text' class='text' name='reportname' id='reportname' size='100' value='<%=checkString(report.getName())%>'/></td>
			<td class='admin2'>
				<table width='100%'>
				<tr><td><%=getTran(request,"web","reportfile",sWebLanguage) %>: <input class='button' type='file' name='reportfile'/></td></tr>
					<%
						boolean bMakeExcelCorrection = false;
						if(report!=null && report.getReportxml()!=null && report.getReportxml().length()>0){
						    SAXReader reader = new SAXReader(false);
							BufferedReader br = new BufferedReader(new StringReader(report.getReportxml()));
							Document document = reader.read(br);
							Element root = document.getRootElement();
							if(root.getName().equalsIgnoreCase("jasperreport")){
								out.println("<tr><td>"+getTran(request,"web","loadedreport",sWebLanguage)+": <a href='javascript:viewJasperReport(\""+report.getUid()+"\")'><b>"+root.attributeValue("name")+"</b></a>&nbsp;&nbsp;&nbsp;<a href='javascript:downloadJasperReport(\""+report.getUid()+"\")'>"+getTran(request,"web","download",sWebLanguage)+"</a></td></tr>");
								Element e = getElement(root, "property", "name","net.sf.jasperreports.export.xls.exclude.origin.keep.first.band.1");
								if(e!=null){
									bMakeExcelCorrection=true;
								}
							}
						}
					%>
					<tr><td><input value='1' type='checkbox' class='text' name='reportmakeexcelcorrection' <%=bMakeExcelCorrection?"checked":"" %>/><%=getTran(request,"web","makeexcelcorrection",sWebLanguage)%></td></tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","reportgroup",sWebLanguage) %></td>
			<td class='admin2' colspan='2' valign='top'>
				<table width='100%'>
					<tr>
						<td>
							<select class='text' name='reportgroup' id='reportgroup' onchange="showaccessrights()">
								<option/>
								<%=ScreenHelper.writeSelect(request,"report.groups", report!=null && report.getGroup()!=null?report.getGroup():"", sWebLanguage) %>
							</select>
						</td>
						<td>
							<input id='showrights' class='text' type='checkbox' onchange='showaccessrights()'/><%=getTran(request,"web","modifyaccessrights",sWebLanguage) %>
						</td>
					</tr>
				</table>
			</td>
			<td class='admin2'>
				<div id='accessrights'></div>
			</td>
		</tr>
		<tr><td colspan='4'><hr/></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","parameters",sWebLanguage) %></td>
			<td class='admin2'>
				<%=getTran(request,"web","name",sWebLanguage) %>: <input type='text' class='text' name='parametername' id='parametername' size='25' value=''/>
				</td><td class='admin2'><%=getTran(request,"web","type",sWebLanguage) %>: 
				<select type='text' class='text' name='parametertype' id='parametertype'>
					<%=ScreenHelper.writeSelect(request,"reportparametertypes","",sWebLanguage) %>
				</select>
				<%=getTran(request,"web","modifier",sWebLanguage) %>: <input type='text' class='text' name='parametermodifier' id='parametermodifier' size='25' value=''/>
			</td>
			<td class='admin2'>
				<input type='button' name='addfieldbutton' value='<%=getTran(null,"web","add",sWebLanguage) %>' onclick='addField();'/>
			</td>
		</tr>
		<tbody name='fieldlistdiv' id='fieldlistdiv'></tbody>
		<%
			}
		%>
	</table>
</form>

<script>
	function showaccessrights(){
		if(document.getElementById('showrights').checked && document.getElementById('reportgroup').value.length>0){
		    var today = new Date();
		    var url= '<c:url value="/system/ajax/modifyReportAccessRights.jsp"/>?reportgroup='+document.getElementById('reportgroup').value+'&title=<%=getTran(request,"web","accesstoreportgroup",sWebLanguage)%>';
			new Ajax.Request(url,{
			  method: "POST",
		      parameters: "",
		      onSuccess: function(resp){
		    	  document.getElementById('accessrights').innerHTML=resp.responseText;
		      }
			});
		}
		else{
	    	  document.getElementById('accessrights').innerHTML="";
		}
	}
	function viewJasperReport(uid){
	    openPopup("/system/viewJasperReport.jsp&ts=<%=getTs()%>&uid="+uid,800,600);
	}
	function downloadJasperReport(uid){
	    window.open("<c:url value="/"/>system/downloadJasperReport.jsp?ts=<%=getTs()%>&uid="+uid);
	}
	function addField(){
		if(document.getElementById("reportinputxml").value.indexOf("<name>"+document.getElementById("parametername").value+"</name>")<0){
			if(document.getElementById("parametername").value.length>0){
				document.getElementById("reportinputxml").value+="<field><name>"+document.getElementById("parametername").value+"</name><type>"+document.getElementById("parametertype").value+"</type><modifier>"+document.getElementById("parametermodifier").value+"</modifier></field>";
				var url= '<c:url value="/system/ajax/showReportFields.jsp"/>';
				new Ajax.Request(url,{
				method: "POST",
				   parameters: "fieldlist="+document.getElementById("reportinputxml").value,
				   onSuccess: function(resp){
					   var html = eval('('+resp.responseText+')');
					   $('fieldlistdiv').innerHTML=html.html;
					}
				});
			}
		}
		else {
			alert('<%=getTranNoLink("web","fieldalreadyexists",sWebLanguage)%>');
		}
	}
	
	function deleteField(name){
			var pos = document.getElementById("reportinputxml").value.indexOf("<field><name>"+name+"</name>");
			var subval = document.getElementById("reportinputxml").value.substring(pos);
			var pos2 = subval.indexOf("</field>");
			subval = subval.substring(0,pos2+8);
			document.getElementById("reportinputxml").value=document.getElementById("reportinputxml").value.replace(subval,'');
			var url= '<c:url value="/system/ajax/showReportFields.jsp"/>';
			new Ajax.Request(url,{
			method: "POST",
			   parameters: "fieldlist="+document.getElementById("reportinputxml").value,
			   onSuccess: function(resp){
				   var html = eval('('+resp.responseText+')');
				   $('fieldlistdiv').innerHTML=html.html;
				}
			});
	}
</script>

<%
	if(checkString(report.getInputxml()).length()>0){
		String sHtml="";
	    SAXReader reader = new SAXReader(false);
		BufferedReader br = new BufferedReader(new StringReader(report.getInputxml()));
		Document document = reader.read(br);
		Element root = document.getRootElement();
		Iterator iFields = root.elementIterator();
		while(iFields.hasNext()){
			Element field = (Element)iFields.next();
			if(field.getName().equalsIgnoreCase("field")){
				sHtml+="<tr><td class='admin'></td><td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteField(\\\""+field.elementText("name")+"\\\");'> "+field.elementText("name")+
						"</td><td class='admin2'>"+getTranNoLink("reportparametertypes",field.elementText("type"),sWebLanguage)+(checkString(field.elementText("type")).length()>0?" ("+field.elementText("type")+(field.elementText("modifier").length()>0?": "+field.elementText("modifier"):"")+")":"")+"</td><td class='admin2'/>";
			}
		}
		out.println("<script>$('fieldlistdiv').innerHTML=\""+sHtml+"\"</script>");
	}
%>

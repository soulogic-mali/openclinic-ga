<%@page import="java.io.*,org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%=sJSPROTOTYPE %>

<%
	
	String sAction = checkString(request.getParameter("action"));
	String sDocumentName = "";
	String sSelectedDocument = "";
	String sXml = "";
	byte[] document=null;
	
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (!isMultipart) {
		Debug.println("NOT MULTIPART");
	}
	else{
	    FileItemFactory factory = new DiskFileItemFactory();
	    ServletFileUpload upload = new ServletFileUpload(factory);
	    List items = null;
	    try {
	        items = upload.parseRequest(request);
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
	        	else if(item.getFieldName().equalsIgnoreCase("documentname")){
	        		sDocumentName = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("xmlfile")){
	        		sXml = item.getString();
	        	}
	        	else if(item.getFieldName().equalsIgnoreCase("selectedDocument")){
	        		sSelectedDocument = item.getString().split(";")[0];
	        	}
	        } else {
	        	try {
	        		if(item.getFieldName().equalsIgnoreCase("documentfile")){
	        			document=item.get();
	        		}
	            } catch (Exception e) {
	                 e.printStackTrace();
	            }
	      	}
		}
	 }	

	
	if(sAction.equalsIgnoreCase("save")){
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps;
		if(sSelectedDocument.length()>0){
			if(document==null || document.length==0){
				//Update name only
				ps = conn.prepareStatement("update WordDocuments set name=?,xml=? where name=?");
				ps.setString(1,sDocumentName);
				ps.setString(2,sXml);
				ps.setString(3,sSelectedDocument);
				ps.execute();
				ps.close();
			}
			else {
				//Update name and document
				ps = conn.prepareStatement("delete from WordDocuments where name=?");
				ps.setString(1,sSelectedDocument);
				ps.execute();
				ps.close();
				ps = conn.prepareStatement("insert into WordDocuments(name,document,xml) values(?,?,?)");
				ps.setString(1,sDocumentName);
				ps.setBytes(2,document);
				ps.setString(3,sXml);
				ps.execute();
				ps.close();
			}
		}
		else {
			//New document
			ps = conn.prepareStatement("insert into WordDocuments(name,document,xml) values(?,?,?)");
			ps.setString(1,sDocumentName);
			ps.setBytes(2,document);
			ps.setString(3,sXml);
			ps.execute();
			ps.close();
		}
	}
	else if(sAction.equalsIgnoreCase("delete")){
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps = conn.prepareStatement("delete from WordDocuments where name=?");
		ps.setString(1,sDocumentName);
		ps.execute();
		ps.close();
	}
%>
<form name='transactionForm' method='post' enctype='multipart/form-data'>
	<input type='hidden' name='action' id='action' value=''/>
	<table width='100%' cellpadding='1' cellspacing='0'>
		<tr class='admin'><td colspan='4'><%=getTran(request,"web.manage","manageworddocuments",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin2'>
				<table width='100%' cellpadding='1' cellspacing='0'>
					<tr>
						<td class='admin' width='10%' rowspan='2' nowrap><%=getTran(request,"web","document",sWebLanguage) %></td>
						<td class='admin2'>
							<select class='text' name='selectedDocument' id='selectedDocument' onchange='document.getElementById("documentname").value=this.value.split(";")[0];document.getElementById("xmlfile").value=this.value.split(";")[1];loaddocument(this.value);'>
								<option value=''><%=getTran(request,"web","new",sWebLanguage) %></option>
								<%
									Connection conn = MedwanQuery.getInstance().getAdminConnection();
									PreparedStatement ps = conn.prepareStatement("select * from WordDocuments order by name");
									ResultSet rs = ps.executeQuery();
									while(rs.next()){
										String name=rs.getString("name");
										String xml=rs.getString("xml");
										out.println("<option value='"+name+";"+xml+"'>"+name+"</option>");
									}
								%>
							</select>
							<input type='button' class='button' name='savebutton' value='<%=getTran(null,"web","save",sWebLanguage) %>' onclick='doSave();'/>
							<input type='button' class='button' name='deletebutton' value='<%=getTran(null,"web","delete",sWebLanguage) %>' onclick='document.getElementById("action").value="delete";transactionForm.submit();'/>
							<input type='button' style='display: none' class='button' name='downloadbutton' id='downloadbutton' value='<%=getTranNoLink("web","download",sWebLanguage) %>' onclick='download();'/>
						</td>
					</tr>
					<tr>
						<td class='admin2'>
							<input type='text' class='text' name='documentname' id='documentname' size='80'/>
						</td> 
					</tr>
					<tr>
						<td class='admin' width='10%' rowspan='2' nowrap><%=getTran(request,"web","optionalxml",sWebLanguage) %></td>
						<td class='admin2'>
							<input type='text' class='text' size='60' name='xmlfile' id='xmlfile'/>
						</td>
					</tr>
				</table>
			</td>
			<td class='admin2'>
				<table width='100%' width='100%' cellpadding='1' cellspacing='0'>
					<tr><td><%=getTran(request,"web","document",sWebLanguage) %>: <input class='button' type='file' name='documentfile'/></td></tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<IFRAME style="display:none" name="hidden-form"></IFRAME>

<script>
	function loaddocument(name){
	    document.getElementById("downloadbutton").style.display='none';
		var url = "<c:url value='/system/loaddocument.jsp'/>?name="+btoa(name);
	    new Ajax.Request(url,
		{
		  	method: "POST",
		  	parameters: "",
		  	onSuccess: function(resp){
			    var respText = convertSpecialCharsToHTML(resp.responseText);
			    var data = eval("("+respText+")");
			    if(document.getElementById("documentname").value.length>0){
			    	document.getElementById("downloadbutton").style.display='';
			    }
	  		},
	  		onFailure: function(resp){
				alert("ERROR :\n"+resp.responseText);
	  		}
		});
	}

	function doSave(){
		document.getElementById("action").value="save";
		transactionForm.submit();
	}
	
	function download(){
		window.open('<%=sCONTEXTPATH%>/system/downloadWordDocument.jsp?name='+btoa(document.getElementById('documentname').value),'hidden-form');
	}
</script>


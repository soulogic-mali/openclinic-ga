<%@page import="javazoom.upload.MultipartFormDataRequest,
                javazoom.upload.UploadFile,org.dom4j.*,org.dom4j.io.*,
                java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.db.*"%>
<%@include file="/includes/validateUser.jsp"%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","c:/temp") %>' />
    <jsp:setProperty name="upBean" property="parser" value="<%= MultipartFormDataRequest.DEFAULTPARSER	 %>"/>
  	<jsp:setProperty name="upBean" property="filesizelimit" value="8589934592"/>
  	<jsp:setProperty name="upBean" property="overwrite" value="true"/>
  	<jsp:setProperty name="upBean" property="dump" value="true"/>
    <jsp:setProperty name="upBean" property="parsertmpdir" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","c:/temp") %>'/>
</jsp:useBean>
<%
	MultipartFormDataRequest mrequest;
	if (MultipartFormDataRequest.isMultipartFormData(request)) {
	    // Uses MultipartFormDataRequest to parse the HTTP request.
		mrequest = new MultipartFormDataRequest(request);
		if (mrequest.getParameter("submit")!=null){
            Hashtable files = mrequest.getFiles();
            if (files != null && !files.isEmpty()){
                UploadFile file = (UploadFile) files.get("filename");
                Picture picture = new Picture();
                picture.setPersonid(Integer.parseInt(activePatient.personid));
                picture.setPicture(file.getData());
                picture.store();
                %>
                <script>
					window.location.href='<c:url value="/main.do"/>';
                </script>
                <%
                out.flush();
            }
		}
	}

%>
<form name='transactionForm' method='post' enctype="multipart/form-data">
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"web","storePicture",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><input class='text' type='file' name='filename'/></td>
		</tr>
	</table>
	<input class='button' type='submit' name='submit' value='<%=getTran(request,"web","save",sWebLanguage) %>'/>
</form>
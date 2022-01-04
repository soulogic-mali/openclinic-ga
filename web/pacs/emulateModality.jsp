<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="org.dcm4che2.data.VR"%>
<%@page import="org.dcm4che2.data.Tag"%>
<%@page import="org.dcm4che2.data.DicomObject"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*"%>
<%@page import="be.openclinic.archiving.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="java.util.*,
                 be.mxs.common.util.db.MedwanQuery,
                 java.io.File,java.io.*,be.mxs.common.util.system.Picture"%>

<%
	String patientid="0";
	String aetitle="OCPX";
	String host="localhost";
	int port=10555;
	if(ServletFileUpload.isMultipartContent(request)){
		try{
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
		        	if(item.getFieldName().equalsIgnoreCase("patientid")){
		        		patientid = item.getString();
		        	}
		        	else if(item.getFieldName().equalsIgnoreCase("aetitle")){
		        		aetitle = item.getString();
		        	}
		        	else if(item.getFieldName().equalsIgnoreCase("host")){
		        		host = item.getString();
		        	}
		        	else if(item.getFieldName().equalsIgnoreCase("port")){
		        		port = Integer.parseInt(item.getString());
		        	}
		        } 
		    }
		    itr = items.iterator();
		    while (itr.hasNext()) {
		        FileItem item = (FileItem) itr.next();
		        if (!item.isFormField() && item.getFieldName().equalsIgnoreCase("filename")) {
					String fullFileName = MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/"+item.getName();
	                if(SH.isAcceptableUploadFileExtension(fullFileName)){
						File dcmFile = new File(fullFileName);
						if(dcmFile.exists()){
							dcmFile.delete();
							dcmFile = new File(fullFileName);
						}
						new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")).mkdirs();
			        	InputStream is = item.getInputStream();
			        	FileUtils.copyInputStreamToFile(is, dcmFile);
			            is.close();
						//Now we have the DICOM file in a local directory and should change the PatientID
						DicomObject obj = Dicom.getDicomObject(fullFileName);
						obj.putString(Tag.PatientID, VR.LO, patientid);
						obj.putString(Tag.StudyInstanceUID, VR.LO, new java.util.Date().getTime()+"");
				    	Dicom.writeDicomObject(obj, new File(fullFileName+".dcm"));
						dcmFile.delete();
						DcmSnd.sendTest(aetitle, host, port, fullFileName+".dcm");
	                }
	                else{
	                	%>
	                	<script>
	                		alert("<%=getTranNoLink("web","forbiddenfiletype",sWebLanguage)%>");
	                		window.close();
	                	</script>
	                	<%
	                }
		        }
		    }
	    }
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
<form name='transactionForm' id='transactionForm' method='post' enctype="multipart/form-data">
	<table width='100%'>
		<tr class='admin'><td  colspan='3'><%=getTran(request,"web","emulatemodality",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin2'>
				<table width='100%'>
					<tr>
						<td class='admin'><%=getTran(request,"web","dicomfile",sWebLanguage) %></td>
						<td class='admin2'><input type='file' size='60' name='filename' id='filename' value=''/></td>
					</tr>
				</table>
			</td>
			<td class='admin2'>
				<center><img height='100px' src='<%=sCONTEXTPATH %>/_img/pacs.png'/></center>
			</td>
			<td class='admin2'>
				<table width='100%'>
					<tr>
						<td class='admin'><%=getTran(request,"web","patientid",sWebLanguage) %></td>
						<td class='admin2'><input type='text' size='10' name='patientid' value='<%=patientid%>'/></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","aetitle",sWebLanguage) %></td>
						<td class='admin2'><input type='text' size='10' name='aetitle' value='<%=aetitle%>'/></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","host",sWebLanguage) %></td>
						<td class='admin2'><input type='text' size='30' name='host' value='<%=host%>'/></td>
					</tr>
					<tr>
						<td class='admin'><%=getTran(request,"web","port",sWebLanguage) %></td>
						<td class='admin2'><input type='text' size='10' name='port' value='<%=port%>'/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<input type='submit' name='submit' value='<%=getTranNoLink("web","send",sWebLanguage) %>'/>
</form>


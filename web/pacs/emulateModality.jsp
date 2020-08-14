<%@page import="org.dcm4che2.data.VR"%>
<%@page import="org.dcm4che2.data.Tag"%>
<%@page import="org.dcm4che2.data.DicomObject"%>
<%@page import="be.openclinic.archiving.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="javazoom.upload.*,
                 java.util.*,
                 be.mxs.common.util.db.MedwanQuery,
                 java.io.File,java.io.*,be.mxs.common.util.system.Picture"%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="storemodel" value="<%=UploadBean.MEMORYSTORE %>" />
</jsp:useBean>
<%
	String patientid="0";
	String aetitle="OCPX";
	String host="localhost";
	int port=10555;
	
	if (MultipartFormDataRequest.isMultipartFormData(request)) {
	    // Uses MultipartFormDataRequest to parse the HTTP request.
	    MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	    if (mrequest !=null) {
	        Hashtable files = mrequest.getFiles();
	        if ( (files != null) && (!files.isEmpty()) ) {
		       	UploadFile file = (UploadFile)files.get("filename");
		        patientid = checkString(mrequest.getParameter("patientid"));
		        aetitle = checkString(mrequest.getParameter("aetitle"));
				host = checkString(mrequest.getParameter("host"));
				port = 10555;
				try{
					port=Integer.parseInt(checkString(mrequest.getParameter("port")));
				}
				catch(Exception e){}
		       	if(file!=null && file.getFileName()!=null){
					String fullFileName = MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")+"/"+file.getFileName();
					File dcmFile = new File(fullFileName);
					if(dcmFile.exists()){
						dcmFile.delete();
						dcmFile = new File(fullFileName);
					}
					new File(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")).mkdirs();
	                upBean.setFolderstore(MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp"));
	                upBean.setParsertmpdir(application.getRealPath("/")+"/"+MedwanQuery.getInstance().getConfigString("tempdir","/tmp/"));
	                upBean.store(mrequest, "filename");
	                //Now we have the DICOM file in a local directory and should change the PatientID
					DicomObject obj = Dicom.getDicomObject(fullFileName);
					obj.putString(Tag.PatientID, VR.LO, patientid);
					obj.putString(Tag.StudyInstanceUID, VR.LO, new java.util.Date().getTime()+"");
			    	Dicom.writeDicomObject(obj, new File(fullFileName+".dcm"));
					dcmFile.delete();
					DcmSnd.sendTest(aetitle, host, port, fullFileName+".dcm");
		       	}
	        }
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

